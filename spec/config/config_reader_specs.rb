

require "aresmush"

module AresMUSH

  describe ConfigReader do

    describe :config_path do 
      it "should be the game dir plus the config dir" do
        allow(AresMUSH).to receive(:game_path) { "game" }
        expect(ConfigReader.config_path).to eq File.join("game", "config")
      end
    end

    describe :config_files do 
      it "searches for files in the config dir" do
        allow(AresMUSH).to receive(:game_path) { "game" }
        expect(Dir).to receive(:[]).with(File.join("game", "config", "**", "*.yml")) { ["a", "b"]}
        expect(ConfigReader.config_files).to eq ["a", "b"]
      end
    end
    
    describe :config do
      before do
        @config_reader = ConfigReader.new
        @config_reader.config = { "a" => { "b" => "c" }, "e" => { "f" => { "g" => "h" } } }
      end
      
      it "should return the section if specified" do
        hash = { "b" => "c" }
        expect(@config_reader.get_config("a")).to eq hash 
      end
      
      it "should return the subsection if specified and the section exists" do
        expect(@config_reader.get_config("a", "b")).to eq "c"
      end
      
      it "should return nil if the section for the requested subsection doesn't exist" do
        expect(@config_reader.get_config("d", "e")).to be_nil
      end
      
      it "should return sub-subsection if it exists" do
        expect(@config_reader.get_config("e", "f", "g")).to eq "h"
      end
      
      it "should return nil if the sub-subsection doesn't exist" do
        expect(@config_reader.get_config("e", "f", "i")).to be_nil 
      end
    end

    describe :load_game_config do 
      before do
        @reader = ConfigReader.new
        allow(ConfigReader).to receive(:config_files) { ["a", "b"] }
      end
      
      it "should read the game config" do        
        config = double
        allow(@reader).to receive(:config) { config }
        
        allow(@reader).to receive(:validate_config_file).with("a") { true }
        allow(@reader).to receive(:validate_config_file).with("b") { true }
        expect(config).to receive(:merge_yaml).with("a")
        expect(config).to receive(:merge_yaml).with("b")
        @reader.load_game_config 
      end 
      
      it "should not read a game config file that has an error" do        
        config = double
        allow(@reader).to receive(:config) { config }
        
        allow(@reader).to receive(:validate_config_file).with("a") { true }
        allow(@reader).to receive(:validate_config_file).with("b").and_raise("error")
        expect(config).to receive(:merge_yaml).with("a")
        expect(config).to_not receive(:merge_yaml).with("b")
        @reader.load_game_config 
      end  
    end
    
    describe :validate_game_config do 
      before do
        @reader = ConfigReader.new
        allow(ConfigReader).to receive(:config_files) { ["a", "b"] }
      end
      
      
      it "should check the config" do        
        config = double
        allow(@reader).to receive(:config) { config }

        expect(AresMUSH::YamlExtensions).to receive(:yaml_hash).with("a").and_raise("error")
        expect(AresMUSH::YamlExtensions).to_not receive(:yaml_hash).with("a")
        expect { @reader.validate_game_config }.to raise_error(RuntimeError)
      end          
    end
  end
end
