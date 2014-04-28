module Cbradeps
  class GemfileDependency
    def initialize(gemspec_line)
      @gemspec_line = gemspec_line.strip
    end

    def name
      match = @gemspec_line.match(/gem\s+["']([^'"]+)["']/)
      match[1] if match
    end

    def path
      match = @gemspec_line.match(/path(?:\s*=>|:)\s+["']([^'"]+)["']/)
      match[1] if match
    end
  end
end