require 'set'
require 'pathname'
require 'graphviz'

module Cbradeps
  require_relative "cobradeps/gemfile_scraper"

  def self.output_text(root_path = nil)
    path = root_path || current_path
    app = GemfileScraper.new(path)

    outputs "APP"
    outputs app.to_s

    outputs "\n\nDEPENDENCIES"
    cobra_deps = app.transitive_cobra_dependencies.to_set

    cobra_deps.each do |dep|
      outputs "\n#{dep[:options][:path]}"
      gem = GemfileScraper.new(dep[:options][:path])
      outputs gem.to_s

      cobra_deps = cobra_deps.merge gem.cobra_dependencies
    end

    outputs "\n\n ALL PARTS"
    outputs cobra_deps.to_a
  end

  def self.output_graph(root_path = nil)
    path = root_path || current_path
    graph(path).output(:png => "graph.png")
  end

  def self.output_dot(root_path = nil)
    path = root_path || current_path
    graph(path).output(:dot => "graph.dot")
  end

  def self.current_path
    `pwd`.chomp
  end

  private_class_method :current_path

  def self.graph(path)
    g = GraphViz.new(:G, :type => :digraph, concentrate: true)

    app = GemfileScraper.new(path)

    app_node = g.add_nodes(app.name)
    outputs "Added #{app.name} node"

    cobra_deps = app.transitive_cobra_dependencies.to_set
    gem_nodes = {}

    cobra_deps.each do |dep|
      gem = GemfileScraper.new(dep[:options][:path])
      gem_node = g.add_nodes(gem.name)
      gem_nodes[gem.name] = gem_node
      outputs "Added #{gem.name} node"
      if dep[:options][:direct]
        outputs "Added edge from #{app.name} to #{gem.name}"
        g.add_edges(app_node, gem_node)
      end
    end

    cobra_deps.each do |dep|
      gem = GemfileScraper.new(dep[:options][:path])
      gem_node = gem_nodes[gem.name]

      gem_cobra_deps = gem.cobra_dependencies
      gem_cobra_deps.each do |nest_dep|
        nest_gem = GemfileScraper.new(nest_dep[:options][:path])
        g.add_edges(gem_node, gem_nodes[nest_gem.name])
        outputs "Added edge from #{gem.name} to #{nest_gem.name}"
      end
    end
    g
  end

  private_class_method :graph

  def self.outputs(arg)
    puts arg
  end

  private_class_method :outputs
end
