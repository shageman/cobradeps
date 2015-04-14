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
    cobra_deps = app.cobra_dependencies.to_a

    i = 0
    while (i < cobra_deps.size) do
      dep = cobra_deps[i]
      outputs "\n#{dep[:options][:path]}"
      gem = GemfileScraper.new(dep[:options][:path])
      outputs gem.to_s

      cobra_deps += gem.cobra_dependencies
      i+=1
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
    gem_nodes = {}

    app = GemfileScraper.new(path)

    app_node = g.add_nodes(app.name)
    gem_nodes[app.name] = app_node
    outputs "Added #{app.name} app"

    cobra_deps = app.cobra_dependencies.to_a

    cobra_deps.each do |dep|
      gem = GemfileScraper.new(dep[:options][:path])
      gem_nodes[gem.name] = g.add_nodes(gem.name)
      outputs "Added #{gem.name} node"
      if dep[:options][:direct]
        outputs "Added edge from #{app.name} to #{gem.name}"
        g.add_edges(app_node, gem_nodes[gem.name])
      end
    end

    i = 0
    while (i < cobra_deps.size) do
      dep = cobra_deps[i]
      gem = GemfileScraper.new(dep[:options][:path])
      if !gem_nodes.has_key? gem.name
          gem_nodes[gem.name] = g.add_nodes(gem.name)
          outputs "Added #{gem.name} node"
      end

      gem_cobra_deps = gem.cobra_dependencies
      gem_cobra_deps.each do |nest_dep|
        nest_gem = GemfileScraper.new(nest_dep[:options][:path])
        if !gem_nodes.has_key? nest_gem.name
          gem_nodes[nest_gem.name] = g.add_nodes(nest_gem.name)
          outputs "Added to #{nest_gem.name} node"
        end
        g.add_edges(gem_nodes[gem.name], gem_nodes[nest_gem.name])
        outputs "Added edge from #{gem.name} to #{nest_gem.name}"
      end
      cobra_deps += gem.cobra_dependencies
      i+=1
    end
    g
  end

  private_class_method :graph

  def self.outputs(arg)
    puts arg
  end

  private_class_method :outputs
end
