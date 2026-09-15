# frozen_string_literal: true

# Locates the machine-readable contents of the ISO 690 test suite for
# implementations that consume it as a gem.
module Iso690TestSuite
  VERSION = "0.1.0"

  class << self
    def root
      File.expand_path("..", __dir__)
    end

    def manifest
      File.join(root, "suite.yaml")
    end

    def tests_dir
      File.join(root, "tests")
    end
  end
end
