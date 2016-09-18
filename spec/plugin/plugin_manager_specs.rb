$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe PluginManager do

    before do
      @temp_dir = "#{Dir.pwd}/tmp_plugin"      
      FileUtils.rm_rf @temp_dir
      Dir.mkdir @temp_dir
      Dir.mkdir File.join(@temp_dir, "plugins")
      @config = double
      @locale = double
      Global.stub(:config_reader) { @config }
      Global.stub(:locale) { @locale }
      AresMUSH.stub(:game_path) { @temp_dir }      
      @manager = PluginManager.new
    end

    after do
      FileUtils.rm_rf @temp_dir
    end

    describe :plugin_path do
      it "should be the game dir plus the plugin dir" do
       AresMUSH.stub(:game_path) { "game" }
       PluginManager.plugin_path.should eq File.join("game", "plugins")
      end
    end
    
    describe :load_plugin_config do
      it "should load all the plugin config files" do
        plugin = double
        plugin.stub(:plugin_dir) { "A" }
        plugin.stub(:config_files) { [ "c1", "c2" ]}
        @config.should_receive(:load_config_file).with("A/c1")
        @config.should_receive(:load_config_file).with("A/c2")
        @manager.load_plugin_config plugin
      end      
    end
    
    describe :validate_plugin_config do
      it "should check the plugin config files" do
        plugin = double
        plugin.stub(:plugin_dir) { "A" }
        plugin.stub(:config_files) { [ "c1", "c2" ]}
        @config.should_receive(:validate_config_file).with("A/c1").and_raise("error")
        @config.should_not_receive(:validate_config_file).with("A/c2")
        expect { @manager.validate_plugin_config plugin }.to raise_error("error")
      end
    end
    
    describe :load_plugin_locale do
      it "should load all the plugin config files" do
        plugin = double
        plugin.stub(:plugin_dir) { "A" }
        plugin.stub(:locale_files) { [ "l1", "l2" ]}
        @locale.should_receive(:add_locale_file).with("A/l1")
        @locale.should_receive(:add_locale_file).with("A/l2")
        @manager.load_plugin_locale plugin
      end
    end    
    
    describe :shortcuts do 
      it "should merge all the plugin shortcuts" do
        p1 = double
        p2 = double      
        @manager.stub(:plugins) { [p1, p2] }
        
        p1.stub(:shortcuts) { { a: 1, b: 2 } }
        p2.stub(:shortcuts) { { c: 3, d: 4 } }
        
        expected = { a: 1, b: 2, c: 3, d: 4 }
        @manager.shortcuts.should eq expected
      end
      
      it "should not blow up on a plugin with no shortcuts" do
        p1 = double
        p2 = double      
        @manager.stub(:plugins) { [p1, p2] }
        
        p1.stub(:shortcuts) { { a: 1, b: 2 } }
        p2.stub(:shortcuts) { nil }
        
        expected = { a: 1, b: 2 }
        @manager.shortcuts.should eq expected
      end
    end
    
  end
end

