module Cbradeps
  class GemspecDependency
    def initialize(gemspec_line)
      @gemspec_line = gemspec_line.strip
    end

    def name
      match = @gemspec_line.match(/add_(development_)?dependency\s+["']([^'"]+)["']/)
      match[2] if match
    end

    def runtime?
      match = @gemspec_line.match(/add_dependency\s+["']([^'"]+)["']/)
      match ? true : false
    end
  end
end