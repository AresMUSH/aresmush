$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe PluginManager do
    include GlobalTestHelper
    
    before do
      stub_global_objects
      AresMUSH.stub(:game_path) { "/game" }      
      @manager = PluginManager.new
    end
    
    describe :load_plugin_config do
      it "should load all the plugin config files" do
        plugin = double
        plugin.stub(:plugin_dir) { "A" }
        plugin.stub(:config_files) { [ "c1", "c2" ]}
        config_reader.should_receive(:load_config_file).with("A/c1")
        config_reader.should_receive(:load_config_file).with("A/c2")
        @manager.load_plugin_config plugin
      end      
    end
    
    describe :validate_plugin_config do
      it "should check the plugin config files" do
        plugin = double
        plugin.stub(:plugin_dir) { "A" }
        plugin.stub(:config_files) { [ "c1", "c2" ]}
        config_reader.should_receive(:validate_config_file).with("A/c1").and_raise("error")
        config_reader.should_not_receive(:validate_config_file).with("A/c2")
        expect { @manager.validate_plugin_config plugin }.to raise_error("error")
      end
    end
    
    describe :load_plugin_locale do
      it "should load all the plugin config files" do
        plugin = double
        plugin.stub(:plugin_dir) { "A" }
        plugin.stub(:locale_files) { [ "l1", "l2" ]}
        locale.should_receive(:add_locale_file).with("A/l1")
        locale.should_receive(:add_locale_file).with("A/l2")
        @manager.load_plugin_locale plugin
      end
    end    
    
    describe :load_plugin_help do
      it "should load all the plugin help files" do
        plugin = double
        Dir.stub(:[]).with("A/help/en/**.md") { [ "h1", "h2" ] }
        plugin.stub(:plugin_dir) { "A" }
        plugin.stub(:to_s) { "AresMUSH::A" }
        locale.stub(:locale_order) { ["en"] }
        help_reader.should_receive(:load_help_file).with("h1", "A")
        help_reader.should_receive(:load_help_file).with("h2", "A")
        @manager.load_plugin_help plugin
      end
      
      it "should read the specific locale and the default one" do
        plugin = double
        Dir.stub(:[]).with("A/help/en/**.md") { [ "en/h1", "en/h2" ] }
        Dir.stub(:[]).with("A/help/de/**.md") { [ "de/h1" ] }
        plugin.stub(:plugin_dir) { "A" }
        plugin.stub(:to_s) { "AresMUSH::A" }
        locale.stub(:locale_order) { ["de", "en"] }
        help_reader.should_receive(:load_help_file).with("de/h1", "A").ordered
        help_reader.should_receive(:load_help_file).with("en/h1", "A").ordered
        help_reader.should_receive(:load_help_file).with("en/h2", "A").ordered
        @manager.load_plugin_help plugin
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

