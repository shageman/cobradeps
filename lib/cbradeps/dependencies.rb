module Cbradeps
  class Dependencies
    def initialize(gem_infos)
      @gem_infos = Hash[gem_infos.map { |gemspec_path, gem_infos| [gemspec_path, GemInfo.new(gemspec_path, gem_infos)] }]
    end

    def dependencies
      Hash[@gem_infos.map { |gemspec_path, gem_info| [gemspec_path, gem_info] }]
    end

    def to_s
      dependencies.map { |key, value| value.to_s }.join("\n")
    end
  end
end
