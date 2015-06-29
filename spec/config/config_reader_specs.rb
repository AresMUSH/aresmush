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
      
      it "should raise error if the section for the requested subsection doesn't exist" do
        expect { @config_reader.get_config("d", "e") }.to raise_error
      end
      
      it "should return sub-subsection if it exists" do
        @config_reader.get_config("e", "f", "g"). should eq "h"
      end
      
      it "should raise error if the sub-subsection doesn't exist" do
        expect { @config_reader.get_config("e", "f", "i"). should eq "h" }.to raise_error
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
        YamlFileParser.should_receive(:read).with( ["a", "b"],  {} ) { parsed1 }
        YamlFileParser.should_receive(:read).with( ["c", "d"],  parsed1 ) { parsed2 }
        @reader.read 
        @reader.config.should eq parsed2
      end    
      
      it "should dispatch the update event" do
        dispatcher = double
        event = double
        ConfigUpdatedEvent.stub(:new) { event }
        Global.stub(:dispatcher) { dispatcher }
        YamlFileParser.should_receive(:read) { {} }
        YamlFileParser.should_receive(:read) { {} }
        dispatcher.should_receive(:queue_event).with(event)
        @reader.read 
      end  
    end
  end
end