require 'spec_helper'

%w(letters letters_block).each do |sample_folder|
  describe Cbradeps do
    describe sample_folder do      
        it "outputs a cobra dependency structure as a dot file" do
          start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", sample_folder, "A"))

          Cbradeps.output_dot(start_path, "spec/test_run")
          
          expected_output = 
<<-DOT
digraph G {
	graph [bb="0,0,158,415",
		concentrate=true
	];
	node [label="\\N"];
	subgraph cluster0 {
		graph [bb="8,8,150,407",
			label=A,
			lheight=0.19,
			lp="79,396",
			lwidth=0.14
		];
		subgraph cluster1 {
			graph [bb="16,376,142,377",
				label="",
				margin="0,0",
				style=invis
			];
			A0			 [fixedsize=true,
				height=0.013889,
				label="",
				margin="0,0",
				pos="43,376.5",
				shape=box,
				style=invis,
				width=0.75];
			A1			 [fixedsize=true,
				height=0.013889,
				label="",
				margin="0,0",
				pos="115,376.5",
				shape=box,
				style=invis,
				width=0.75];
		}
		B		 [height=0.5,
			label=B,
			pos="43,322",
			width=0.75];
		A0 -> B		 [pos="e,43,340.26 43,375.89 43,373.17 43,361.85 43,350.28"];
		C		 [height=0.5,
			label=C,
			pos="72,250",
			width=0.75];
		A1 -> C		 [pos="e,77.987,267.61 114.73,375.69 112.21,368.3 93.032,311.87 81.24,277.18"];
		B -> C		 [pos="e,64.944,267.52 50.02,304.57 53.344,296.32 57.39,286.27 61.1,277.06"];
		D		 [height=0.5,
			label=D,
			pos="72,178",
			width=0.75];
		C -> D		 [pos="e,72,196.41 72,231.83 72,224.13 72,214.97 72,206.42"];
		C -> D;
		E1		 [height=0.5,
			label=E1,
			pos="43,106",
			width=0.75];
		D -> E1		 [pos="e,50.056,123.52 64.98,160.57 61.656,152.32 57.61,142.27 53.9,133.06"];
		D -> E1;
		E2		 [height=0.5,
			label=E2,
			pos="115,106",
			width=0.75];
		D -> E2		 [pos="e,104.88,122.94 82.19,160.94 87.385,152.24 93.811,141.48 99.595,131.79"];
		D -> E2;
		F		 [height=0.5,
			label=F,
			pos="79,34",
			width=0.75];
		E1 -> F		 [pos="e,70.366,51.269 51.715,88.571 55.96,80.081 61.154,69.693 65.866,60.267"];
		E1 -> F;
		E2 -> F		 [pos="e,87.634,51.269 106.29,88.571 102.04,80.081 96.846,69.693 92.134,60.267"];
		E2 -> F;
	}
}
DOT


          file = File.open(File.expand_path("../../test_run.dot", __FILE__), "r")
          contents = file.read
          expect(contents).to eq(expected_output)
        end
      end
    end
  end