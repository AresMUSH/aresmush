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
    
    describe :line do
      it "is an alias to the theme line" do
        reader = ConfigReader.new
        reader.stub(:line_color) { "c" }
        reader.config = {"theme" => {"line1" => "---"}}
        reader.line("1").should eq "---"
      end
      
      it "can read any arbitrary line" do
        reader = ConfigReader.new
        reader.stub(:line_color) { "c" }
        reader.config = {"theme" => {"line_top" => "---"}}
        reader.line("_top").should eq "---"
      end
      
      it "should default to a blank line if the specified one doesn't exist" do
        reader = ConfigReader.new
        reader.stub(:line_color) { "c" }
        reader.config = {"theme" => {"line2" => "---"}}
        reader.line("xxx").should eq  ""
      end
    end

    describe :clear_config do
      it "clears any previous config" do
        @reader = ConfigReader.new
        @reader.config['x'] = 'y'
        @reader.clear_config
        @reader.config.has_key?('x').should be_false
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
        
        ConfigFileParser.should_receive(:read).with( ["a", "b"],  {} ) { parsed1 }
        ConfigFileParser.should_receive(:read).with( ["c", "d"],  parsed1 ) { parsed2 }
        @reader.read 
        @reader.config.should eq parsed2
      end
      
      it "should erase prior config" do
        @reader.config = { "a" => "b" }
        parsed = { "c" => "d" }
        
        ConfigFileParser.should_receive(:read).with( ["a", "b"],  {} ) { parsed }
        ConfigFileParser.should_receive(:read).with( ["c", "d"],  parsed ) { parsed }
        @reader.read 
        @reader.config.has_key?("a").should be_false
      end
    end
  end
end