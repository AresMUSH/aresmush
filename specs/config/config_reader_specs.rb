$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

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
        Dir.should_receive(:[]).with(File.join("game", "config", "**")) { ["a", "b"]}
        ConfigReader.config_files.should eq ["a", "b"]
      end
    end
    

    describe :read do 
      before do
        @reader = ConfigReader.new
        ConfigReader.stub(:config_files) { ["a", "b"] }
        PluginManager.should_receive(:config_files) { [ "c", "d" ]}        
      end
      
      it "should read the main and plugin config" do        
        parsed1 = { "c" => "d" }
        parsed2 = { "e" => "f" }
        
        # The first {} is what makes sure the prior config was erased
        ConfigFileParser.should_receive(:read).with( ["a", "b"],  {} ) { parsed1 }
        ConfigFileParser.should_receive(:read).with( ["c", "d"],  parsed1 ) { parsed2 }
        @reader.read 
        @reader.config.should eq parsed2
      end      
    end
  end
end