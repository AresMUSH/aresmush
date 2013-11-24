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
        ConfigReader.stub(:config_files) { [] }
        PluginManager.stub(:config_files) { [] }
      end

      it "clears any previous config" do
        @reader.should_receive(:clear_config)
        @reader.read
      end

      it "reads the main config files" do
        ConfigReader.stub(:config_files) { ["a", "b"] }
        YamlExtensions.should_receive(:yaml_hash).with("a") { {} }
        YamlExtensions.should_receive(:yaml_hash).with("b") { {} }
        @reader.read 
      end
      
       it "reads the plugin config files" do
          ConfigReader.stub(:config_files) { [] }
          PluginManager.should_receive(:config_files) { [ "a", "b" ]}
          YamlExtensions.should_receive(:yaml_hash).with("a") { {} }
          YamlExtensions.should_receive(:yaml_hash).with("b") { {} }
          @reader.read 
        end
      
      it "merges all the configs together" do
        ConfigReader.stub(:config_files) { ["a", "b"] }
        PluginManager.should_receive(:config_files) { [ "c", "d" ]}
        YamlExtensions.should_receive(:yaml_hash).with("a") { { 'test' => { 'a' => 1 } } }
        YamlExtensions.should_receive(:yaml_hash).with("b") { { 'test' => { 'b' => 2 } } }
        YamlExtensions.should_receive(:yaml_hash).with("c") { { 'test' => { 'c' => 3 } } }
        YamlExtensions.should_receive(:yaml_hash).with("d") { { 'test' => { 'd' => 4 } } }

        @reader.read 
        @reader.config['test']['a'].should eq 1
        @reader.config['test']['b'].should eq 2
        @reader.config['test']['c'].should eq 3
        @reader.config['test']['d'].should eq 4
      end
    end
  end
end