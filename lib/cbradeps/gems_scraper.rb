module Cbradeps
  class GemsScraper
    def initialize(root_path)
      @root_path = root_path
    end

    def gem_infos
      gemspec_paths.inject({@root_path => app_as_gem_info}) do |memo, gemspec_path|
        gemspec_path_folder = gemspec_path.gsub(/\/[^\/]+$/, "")
        memo[gemspec_path_folder] = gem_info_contents(gemspec_path)
        memo
      end
    end

    private

    def app_as_gem_info
      gemfile_path = File.expand_path(File.join(@root_path, "Gemfile"))
      {
          raw_gemspec: nil,
          raw_gemfile: (File.exists?(gemfile_path) ? File.read(gemfile_path).split("\n") : nil),
      }
    end

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
  end
end