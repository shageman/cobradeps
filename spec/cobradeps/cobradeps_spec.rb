require 'spec_helper'

describe Cbradeps do
  before do
    @puts = []
    Cbradeps.stub(:outputs) do |arg|
      @puts << arg
    end
  end

  it "outputs a cobra dependency structure as text" do
    start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", "letters", "E1"))
    expected_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", "letters", "F"))

    Cbradeps.output_text(start_path)
    expect(@puts).to eq(
                         ["APP",
                          [{:name => "F", :options => {:path => expected_path}}],
                          "\n\nDEPENDENCIES",
                          "\n#{expected_path}",
                          [],
                          "\n\n ALL PARTS",
                          [{:name => "F", :options => {:path => expected_path}}]
                         ])
  end

  describe "graph exports" do
    before do
      @graph = []
      @mock_graph = double
      @mock_graph.stub(:add_nodes) do |arg|
        @graph << arg
        arg
      end
      @mock_graph.stub(:add_edges) do |*args|
        @graph << args
      end
      @mock_graph.stub(:output)
      GraphViz.stub(:new).and_return @mock_graph
    end

    it "outputs a cobra dependency structure as a png" do
      start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", "letters", "A"))

      @mock_graph.should_receive(:output).with({:png => "graph.png"})

      Cbradeps.output_graph(start_path)
      expect(@puts).to eq(
                           [
                               "Added A node",
                               "Added B node",
                               "Added edge from A to B",
                               "Added C node",
                               "Added D node",
                               "Added E1 node",
                               "Added E2 node",
                               "Added F node",
                               "Added edge from B to C",
                               "Added edge from C to D",
                               "Added edge from D to E1",
                               "Added edge from D to E2",
                               "Added edge from E1 to F",
                               "Added edge from E2 to F"]
                       )
      expect(@graph).to eq ([
          "A",
          "B",
          ["A", "B"],
          "C",
          "D",
          "E1",
          "E2",
          "F",
          ["B", "C"],
          ["C", "D"],
          ["D", "E1"],
          ["D", "E2"],
          ["E1", "F"],
          ["E2", "F"]
      ])
    end

    it "outputs a cobra dependency structure as a dot file" do
      start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", "letters", "A"))

      @mock_graph.should_receive(:output).with({:dot => "graph.dot"})

      Cbradeps.output_dot(start_path)
      expect(@puts).to eq(
                           [
                               "Added A node",
                               "Added B node",
                               "Added edge from A to B",
                               "Added C node",
                               "Added D node",
                               "Added E1 node",
                               "Added E2 node",
                               "Added F node",
                               "Added edge from B to C",
                               "Added edge from C to D",
                               "Added edge from D to E1",
                               "Added edge from D to E2",
                               "Added edge from E1 to F",
                               "Added edge from E2 to F"]
                       )
      expect(@graph).to eq ([
          "A",
          "B",
          ["A", "B"],
          "C",
          "D",
          "E1",
          "E2",
          "F",
          ["B", "C"],
          ["C", "D"],
          ["D", "E1"],
          ["D", "E2"],
          ["E1", "F"],
          ["E2", "F"]
      ])
    end
  end
end
