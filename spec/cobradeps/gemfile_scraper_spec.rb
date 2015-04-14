require 'spec_helper'

%w(letters letters_block).each do |sample_folder|
  describe Cbradeps::GemfileScraper do
    describe sample_folder do
      it "'s name is the last part of the given path" do
        expect(described_class.new("some/path_with/a/special_name").name).to eq "special_name"
      end

      describe "#cobra_dependencies" do
        it "returns an array of hashes of the direct cobra_dependencies" do
          start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", sample_folder, "A"))
          expected_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", sample_folder, "B"))

          scraper = described_class.new(start_path)
          expect(scraper.cobra_dependencies).to eq([
                                                       {:name => "B",
                                                        :options =>
                                                            {
                                                                :path => expected_path,
                                                                :direct => true
                                                            }
                                                       }
                                                   ])
        end

        it "returns an array of hashes of the runtime cobra_dependencies of a gem" do
          start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", sample_folder, "B"))
          expected_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", sample_folder, "C"))

          dependencies = described_class.new(start_path).cobra_dependencies
          expect(dependencies.size).to eq 1
          expect(dependencies.first[:name]).to eq "C"
          expect(dependencies.first[:options][:path]).to eq expected_path
        end
      end
    end
  end
end