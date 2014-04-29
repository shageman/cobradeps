module Cbradeps
  class GemfileDependency
    def initialize(root_path, gemfile_line)
      @gemfile_line = gemfile_line.strip
      @root_path = root_path
    end

    def name
      match = @gemfile_line.match(/gem\s+["']([^'"]+)["']/)
      match[1] if match
    end

    def path
      File.expand_path(File.join(@root_path, sub_path))
    end

    private

    def sub_path
      match = @gemfile_line.match(/path(?:\s*=>|:)\s+["']([^'"]+)["']/)
      match[1] if match
    end
  end
end