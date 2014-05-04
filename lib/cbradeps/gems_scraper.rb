module Cbradeps
  class GemsScraper
    def initialize(root_path)
      @root_path = root_path
    end

    def gem_infos
      gemspec_paths.inject({}) do |memo, gemspec_path|
        gemspec_path_folder = gemspec_path.gsub(/\/[^\/]+$/, "")
        memo[gemspec_path_folder] = gem_info_contents(gemspec_path)
        memo
      end
    end

    private

    def gem_info_contents(gemspec_path)
      gemfile_path = gemspec_path.sub(/\/[^\/]+.gemspec/, "/Gemfile")
      {
          raw_gemspec: File.read(gemspec_path).split("\n"),
          raw_gemfile: (File.exists?(gemfile_path) ? File.read(gemfile_path).split("\n") : nil),
      }
    end

    def gemspec_paths
      `find #{@root_path} -iname "*.gemspec"`.split("\n")
    end

    def gemfile_paths
      `find #{@root_path} -iname "Gemfile"`.split("\n")
    end
  end
end