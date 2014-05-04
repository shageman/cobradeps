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
