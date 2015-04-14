module Cbradeps
  class GemfileScraper
    def initialize(root_path)
      @root_path = root_path
    end

    def name
      Pathname.new(@root_path).basename.to_s
    end

    def to_s
      cobra_dependencies
    end

    def cobra_dependencies
      dirdep = direct_dependencies
      transitive_cobra_dependencies.select do |dep|
        dirdep.include?(dep[:name]) || dep[:options][:direct]
      end
    end

    private

    def transitive_cobra_dependencies
      gem_dependencies.inject([]) do |memo, dep|
        if !!dep[:options][:path]
          absolute_dep = dep.clone
          absolute_dep[:options][:path] = File.expand_path(File.join(@root_path, dep[:options][:path]))
          memo << dep
        end
        memo
      end
    end

    def raw_gemspec
      path = File.expand_path(File.join(@root_path, "#{underscore(name)}.gemspec"))
      File.exist?(path) ? File.read(path) : ""
    end

    def direct_dependencies
      raw_gemspec.split("\n").inject([]) do |memo, line|
        match = line.match(/add_(?:development_)?dependency\s+["']([^'"]+)["']/)
        memo << match[1] if match
        memo
      end
    end

    def raw_gemfile
      path = File.expand_path(File.join(@root_path, "Gemfile"))
      File.read(path)
    end

    def gem_dependencies
      in_path_block_dir = nil
      raw_gemfile.split("\n").inject([]) do |memo, line|
        if in_path_block_dir
          if match = line.match(/gem\s+["']([^'"]+)["'](.*)/)
            memo << {name: match[1], options: {path: "#{in_path_block_dir}/#{match[1]}", direct: true}}
          elsif line.match(/end/)
            in_path_block_dir = nil
          end
        else
          if match = line.match(/gem\s+["']([^'"]+)["'](.*)/)
            memo << {name: match[1], options: NonBlockOptionParser.new(match[2]).parse}
          elsif match = line.match(/path\s+[\"\'\:]?([^\"\']*)[\"\']?\s+do/)
            in_path_block_dir = match[1]
          end
        end
        memo
      end
    end

    def underscore(string)
      string.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z\d])([A-Z])/, '\1_\2').
          tr("-", "_").
          downcase
    end

    class NonBlockOptionParser
      def initialize(options)
        @options = options
      end

      def parse
        {}.merge(path).merge(direct)
      end

      private

      def path
        match = @options.match(/path(?:\s*=>|:)\s+["']([^'"]+)["']/)
        match ? {path: match[1]} : {}
      end

      def direct
        match = @options.match(/group(?:\s*=>|:)\s+:direct/)
        match ? {direct: true} : {}
      end
    end
  end
end