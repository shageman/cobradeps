module Cbradeps
  class GemInfo
    def initialize(gemspec_path, info)
      @gemspec_path = gemspec_path
      @raw_gemspec = info[:raw_gemspec]
      @raw_gemfile = info[:raw_gemfile]
    end

    def to_s
      "#{@gemspec_path}" +
          "\n    gemfile: #{@raw_gemfile ? "yes" : "no"}" +
          "\n    gemspec: #{!!@raw_gemspec ? "yes" : "no"} " +
          "\n    cbra dependency paths: #{puts_with_preceding_newline(cbra_dependency_paths)}" +
          "\n    runtime dependencies: #{puts_with_preceding_newline(runtime_dependency_names)}" +
          "\n    test dependencies: #{puts_with_preceding_newline(test_dependency_names)}"
    end

    private

    def cbra_dependency_paths
      return [] unless @raw_gemfile
      @raw_gemfile.map { |line| GemfileDependency.new(@gemspec_path, line) }.select{|dep| dep.name }.map(&:path).compact
    end

    def runtime_dependency_names
      return [] unless @raw_gemspec
      @raw_gemspec.map { |line| GemspecDependency.new(line) }.select{|dep| dep.runtime? }.map(&:name).compact
    end

    def test_dependency_names
      return [] unless @raw_gemspec
      @raw_gemspec.map { |line| GemspecDependency.new(line) }.select{|dep| !dep.runtime? }.map(&:name).compact
    end

    def puts_with_preceding_newline(array)
      result = ""
      result += "\n        " unless array.empty?
      result + array.join("\n        ")
    end
  end
end
