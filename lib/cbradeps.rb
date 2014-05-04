#TODO handle nested rails app (detect folders with only gemfiles too)
#TODO optionally output dotfile for internal deps
#TODO optionally output dotfile for all deps
#TODO support windows folders (searching for a couple slashes)
#TODO support windows: don't shell out to find gemspecs and gemfiles
#TODO - info if no gem file found for gem
#TODO - warn if gem has name different than folder
#TODO - warn if same gem name is found with path and without
#TODO - error if there are multiple gem specs
#TODO - error if there is not gem file in root

module Cbradeps
  require_relative "cbradeps/dependencies"
  require_relative "cbradeps/gem_info"
  require_relative "cbradeps/gems_scraper"
  require_relative "cbradeps/gemfile_dependency"
  require_relative "cbradeps/gemspec_dependency"

  def self.call(root_path = nil)
    path = root_path || current_path
    puts Dependencies.new(GemsScraper.new(path).gem_infos)
  end

  def self.current_path
    `pwd`.chomp
  end
  private_class_method :current_path
end
