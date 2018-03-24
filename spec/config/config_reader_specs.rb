$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe ConfigReader do

    describe :config_path do 
      it "should be the game dir plus the config dir" do
        AresMUSH.stub(:game_path) { "game" }
        ConfigReader.config_path.should eq File.join("game", "config")
      end
    end

    describe :config_files do 
      it "searches for files in the config dir" do
        AresMUSH.stub(:game_path) { "game" }
        Dir.should_receive(:[]).with(File.join("game", "config", "**", "*.yml")) { ["a", "b"]}
        ConfigReader.config_files.should eq ["a", "b"]
      end
    end
    
    describe :config do
      before do
        @config_reader = ConfigReader.new
        @config_reader.config = { "a" => { "b" => "c" }, "e" => { "f" => { "g" => "h" } } }
      end
      
      it "should return the section if specified" do
        hash = { "b" => "c" }
        @config_reader.get_config("a").should eq hash 
      end
      
      it "should return the subsection if specified and the section exists" do
        @config_reader.get_config("a", "b").should eq "c"
      end
      
      it "should return nil if the section for the requested subsection doesn't exist" do
        @config_reader.get_config("d", "e").should be_nil
      end
      
      it "should return sub-subsection if it exists" do
        @config_reader.get_config("e", "f", "g"). should eq "h"
      end
      
      it "should return nil if the sub-subsection doesn't exist" do
        @config_reader.get_config("e", "f", "i"). should be_nil 
      end
    end

    describe :load_game_config do 
      before do
        @reader = ConfigReader.new
        ConfigReader.stub(:config_files) { ["a", "b"] }
      end
      
      it "should read the game config" do        
        config = double
        @reader.stub(:config) { config }
        
        @reader.stub(:validate_config_file).with("a") { true }
        @reader.stub(:validate_config_file).with("b") { true }
        config.should_receive(:merge_yaml).with("a")
        config.should_receive(:merge_yaml).with("b")
        @reader.load_game_config 
      end 
      
      it "should not read a game config file that has an error" do        
        config = double
        @reader.stub(:config) { config }
        
        @reader.stub(:validate_config_file).with("a") { true }
        @reader.stub(:validate_config_file).with("b").and_raise("error")
        config.should_receive(:merge_yaml).with("a")
        config.should_not_receive(:merge_yaml).with("b")
        @reader.load_game_config 
      end  
    end
    
    describe :validate_game_config do 
      before do
        @reader = ConfigReader.new
        ConfigReader.stub(:config_files) { ["a", "b"] }
      end
      
      
      it "should check the config" do        
        config = double
        @reader.stub(:config) { config }

        AresMUSH::YamlExtensions.should_receive(:yaml_hash).with("a").and_raise("error")
        AresMUSH::YamlExtensions.should_not_receive(:yaml_hash).with("a")
        expect { @reader.validate_game_config }.to raise_error(RuntimeError)
      end          
    end
  end
end