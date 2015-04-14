require 'spec_helper'

%w(letters letters_block).each do |sample_folder|
  describe Cbradeps do
    describe sample_folder do
      before do
        @puts = []
        Cbradeps.stub(:outputs) do |arg|
          @puts << arg
        end
      end

        it "outputs a cobra dependency structure as text" do
          start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", sample_folder, "E1"))
          expected_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", sample_folder, "F"))

          Cbradeps.output_text(start_path)
          expect(@puts[0]).to eq("APP")
          expect(@puts[1].size).to eq(1)
          expect(@puts[1].first[:name]).to eq("F")
          expect(@puts[1].first[:options][:path]).to eq(expected_path)
          expect(@puts[2]).to eq("\n\nDEPENDENCIES")
          expect(@puts[3]).to eq("\n#{expected_path}")
          expect(@puts[4]).to eq([])
          expect(@puts[5]).to eq("\n\n ALL PARTS")
          expect(@puts[6].size).to eq(1)
          expect(@puts[6].first[:name]).to eq("F")
          expect(@puts[6].first[:options][:path]).to eq(expected_path)
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
          start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", sample_folder, "A"))

          @mock_graph.should_receive(:output).with({:png => "graph.png"})

          Cbradeps.output_graph(start_path)
          expect(@puts).to eq(
                               ["Added A app",
                                "Added B node",
                                "Added edge from A to B",
                                "Added to C node",
                                "Added edge from B to C",
                                "Added to D node",
                                "Added edge from C to D",
                                "Added to E1 node",
                                "Added edge from D to E1",
                                "Added to E2 node",
                                "Added edge from D to E2",
                                "Added to F node",
                                "Added edge from E1 to F",
                                "Added edge from E2 to F"])
          expect(@graph).to eq (["A", "B", ["A", "B"], "C", ["B", "C"], "D",
                                 ["C", "D"], "E1", ["D", "E1"], "E2",
                                 ["D", "E2"], "F", ["E1", "F"], ["E2", "F"]])
        end

        it "outputs a cobra dependency structure as a dot file" do
          start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", sample_folder, "A"))

          @mock_graph.should_receive(:output).with({:dot => "graph.dot"})

          Cbradeps.output_dot(start_path)
          expect(@puts).to eq(
                               ["Added A app",
                                "Added B node",
                                "Added edge from A to B",
                                "Added to C node",
                                "Added edge from B to C",
                                "Added to D node",
                                "Added edge from C to D",
                                "Added to E1 node",
                                "Added edge from D to E1",
                                "Added to E2 node",
                                "Added edge from D to E2",
                                "Added to F node",
                                "Added edge from E1 to F",
                                "Added edge from E2 to F"])
          expect(@graph).to eq (["A", "B", ["A", "B"], "C", ["B", "C"], "D",
                                 ["C", "D"], "E1", ["D", "E1"], "E2",
                                 ["D", "E2"], "F", ["E1", "F"], ["E2", "F"]])
        end
      end
    end
  end
end
