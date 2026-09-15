# frozen_string_literal: true

desc "Validate the corpus: schemas, unique ids, pending completeness"
task :validate do
  sh "ruby #{File.join(__dir__, 'tools', 'validate.rb')}"
end

task default: :validate
