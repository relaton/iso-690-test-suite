#!/usr/bin/env ruby
# frozen_string_literal: true

# Gem-free corpus validation: every YAML file validates against its JSON
# Schema, test ids are unique, and pending entries stay complete.
# Implementations consuming this suite (any language) get the same
# guarantees before running the corpus.

require "yaml"
require "json"
require "set"
require "json_schemer"

REPO = File.expand_path("..", __dir__)
failures = []

suite_schema = JSONSchemer.schema(YAML.safe_load_file(
  File.join(REPO, "schema", "suite.yaml")
))
test_schema = JSONSchemer.schema(YAML.safe_load_file(
  File.join(REPO, "schema", "test.yaml")
))

suite = YAML.safe_load_file(File.join(REPO, "suite.yaml"))
suite_schema.validate(suite).each do |error|
  failures << "suite.yaml schema: #{JSON.generate(error)}"
end

tests_dir = File.join(REPO, "tests")
test_files = Dir[File.join(tests_dir, "*.yaml")].sort
failures << "no test files under tests/" if test_files.empty?

ids = Set.new
case_count = 0
pending_count = 0

test_files.each do |path|
  rel = path.delete_prefix("#{REPO}/")
  records = YAML.safe_load_file(path)
  test_schema.validate(records).each do |error|
    failures << "#{rel} schema: #{JSON.generate(error)}"
  end
  records.each do |test|
    id = test["id"]
    failures << "#{rel}: duplicate id #{id}" unless ids.add?(id)
    pending_count += 1 if test["pending"]
    if test["pending"] && (!test.dig("given", "bibitem") ||
        test.dig("expect", "rendering").to_s.empty?)
      failures << "#{rel}: pending entry #{id} lacks given/expect"
    end
    case_count += 1
  end
rescue StandardError => e
  failures << "#{rel}: #{e.class}: #{e.message}"
end

puts "tests: #{test_files.size} files, #{case_count} cases " \
     "(#{pending_count} pending), #{ids.size} unique ids"
puts failures.empty? ? "VALIDATION PASS" : "VALIDATION FAIL:"
failures.each { |f| puts "  #{f}" }
exit(failures.empty? ? 0 : 1)
