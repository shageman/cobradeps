require 'set'

module Cbradeps
  require_relative "cbradeps/gemfile_scraper"

  def self.call(root_path = nil)
    path = root_path || current_path
    app = GemfileScraper.new(path)

    puts "APP"
    puts app.to_s

    puts "\n\nDEPENDENCIES"
    cbra_deps = app.cbra_dependencies.to_set

    cbra_deps.each do |dep|
      puts "\n#{dep[:options][:path]}"
      gem = GemfileScraper.new(dep[:options][:path])
      puts gem.to_s

      cbra_deps = cbra_deps.merge gem.cbra_dependencies
    end

    puts "\n\n ALL PARTS"
    puts cbra_deps.to_a
  end

  def self.current_path
    `pwd`.chomp
  end
  private_class_method :current_path
end
