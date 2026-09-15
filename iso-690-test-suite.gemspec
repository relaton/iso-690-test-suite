# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "iso_690_test_suite"

Gem::Specification.new do |spec|
  spec.name          = "iso-690-test-suite"
  spec.version       = Iso690TestSuite::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.summary       = "ISO 690 machine-readable rendering test suite"
  spec.description   = "Machine-readable rendering tests for ISO 690:2010, " \
                       "built from the standard's clause 8 worked examples. " \
                       "Inputs are relaton v3 bibitem XML; expected outputs " \
                       "are strings keyed by rendering style and language."
  spec.homepage      = "https://github.com/relaton/iso-690-test-suite"
  spec.license       = "BSD-2-Clause"

  spec.files = %w[README.adoc LICENSE suite.yaml] +
               Dir["schema/*.yaml"] + Dir["tests/*.yaml"] +
               Dir["lib/**/*.rb"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
