module Cbradeps
  class GemfileScraper
    def initialize(root_path)
      @root_path = root_path
    end

    def to_s
      cbra_dependencies
    end

    def cbra_dependencies
      gem_dependencies.inject([]) do |memo, dep|
        if !!dep[:options][:path]
          absolute_dep = dep.clone
          absolute_dep[:options][:path] = File.expand_path(File.join(@root_path, dep[:options][:path]))
          memo << dep
        end
        memo
      end
    end

    private
    
    def raw_gemfile
      path = File.expand_path(File.join(@root_path, "Gemfile"))
      File.read(path)
    end
    
    def gem_dependencies
      raw_gemfile.split("\n").inject([]) do |memo, line|
        match = line.match(/gem\s+["']([^'"]+)["'](.*)/)
        if match
          memo << {dependency: match[1], options: OptionParser.new(match[2]).parse}
        end
        memo
      end
    end
    
    class OptionParser
      def initialize(options)
        @options = options
      end
      
      def parse
        {}.merge(path)
      end
      
      def path
        match = @options.match(/path(?:\s*=>|:)\s+["']([^'"]+)["']/)
        match ? {path: match[1]} : {}
      end
    end
  end
end