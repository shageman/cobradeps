# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'cobradeps'
  spec.version       = '0.3.1'
  spec.authors       = ['Stephan Hagemann']
  spec.email         = ['stephan.hagemann@gmail.com']
  spec.summary       = %q{Prints and exports the dependencies within component-based Ruby/Rails applications}
  spec.description   = <<-DOC
Component-based Ruby/Rails applications use local 'path' gem references to structure an application. This gem provides
utilities for printing and exporting such dependencies.
DOC

  spec.homepage      = 'https://github.com/shageman/cobradeps'
  spec.license       = 'MIT'

  spec.files         = %w(
                          bin/cobradeps
                          cobradeps.gemspec
                          Gemfile
                          lib/cobradeps/gemfile_scraper.rb
                          lib/cobradeps.rb
                          LICENSE
                          Rakefile
                          README.md
                          )

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'ruby-graphviz'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
