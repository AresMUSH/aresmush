$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe PluginManager do
    include GlobalTestHelper
    
    before do
      stub_global_objects
      allow(AresMUSH).to receive(:game_path) { "/game" }      
      @manager = PluginManager.new
      allow(Global).to receive(:read_config).with("plugins", "disabled_plugins") { [] }
    end
    
    describe :load_plugin_locale do
      it "should load all the plugin config files for all locales in order" do
        plugin = double
        allow(plugin).to receive(:plugin_dir) { "A" }
        allow(locale).to receive(:locale_order) { [ "l1", "l2" ]}
        allow(File).to receive(:exists?).with("A/locales/locale_l1.yml") { true }
        allow(File).to receive(:exists?).with("A/locales/locale_l2.yml") { true }
        expect(locale).to receive(:add_locale_file).with("A/locales/locale_l1.yml")
        expect(locale).to receive(:add_locale_file).with("A/locales/locale_l2.yml")
        @manager.load_plugin_locale plugin
      end
      
      it "should not load a plugin file if it doesn't exist" do
        plugin = double
        allow(plugin).to receive(:plugin_dir) { "A" }
        allow(locale).to receive(:locale_order) { [ "l1", "l2" ]}
        allow(File).to receive(:exists?).with("A/locales/locale_l1.yml") { true }
        allow(File).to receive(:exists?).with("A/locales/locale_l2.yml") { false }
        expect(locale).to receive(:add_locale_file).with("A/locales/locale_l1.yml")
        expect(locale).to_not receive(:add_locale_file).with("A/locales/locale_l2.yml")
        @manager.load_plugin_locale plugin
      end
    end    
    
    describe :load_plugin_help do
      it "should load all the plugin help files" do
        plugin = double
        allow(Dir).to receive(:[]).with("A/help/en/**.md") { [ "h1", "h2" ] }
        allow(plugin).to receive(:plugin_dir) { "A" }
        allow(plugin).to receive(:to_s) { "AresMUSH::A" }
        allow(locale).to receive(:locale_order) { ["en"] }
        expect(help_reader).to receive(:load_help_file).with("h1", "A")
        expect(help_reader).to receive(:load_help_file).with("h2", "A")
        @manager.load_plugin_help plugin
      end
      
      it "should read the specific locale and the default one" do
        plugin = double
        allow(Dir).to receive(:[]).with("A/help/en/**.md") { [ "en/h1", "en/h2" ] }
        allow(Dir).to receive(:[]).with("A/help/de/**.md") { [ "de/h1" ] }
        allow(plugin).to receive(:plugin_dir) { "A" }
        allow(plugin).to receive(:to_s) { "AresMUSH::A" }
        allow(locale).to receive(:locale_order) { ["de", "en"] }
        expect(help_reader).to receive(:load_help_file).with("de/h1", "A").ordered
        expect(help_reader).to receive(:load_help_file).with("en/h1", "A").ordered
        expect(help_reader).to receive(:load_help_file).with("en/h2", "A").ordered
        @manager.load_plugin_help plugin
      end
    end 
    
    describe :shortcuts do 
      it "should merge all the plugin shortcuts" do
        p1 = double
        p2 = double      
        allow(@manager).to receive(:plugins) { [p1, p2] }
        
        allow(p1).to receive(:shortcuts) { { a: 1, b: 2 } }
        allow(p2).to receive(:shortcuts) { { c: 3, d: 4 } }
        
        expected = { a: 1, b: 2, c: 3, d: 4 }
        expect(@manager.shortcuts).to eq expected
      end
      
      it "should not blow up on a plugin with no shortcuts" do
        p1 = double
        p2 = double      
        allow(@manager).to receive(:plugins) { [p1, p2] }
        
        allow(p1).to receive(:shortcuts) { { a: 1, b: 2 } }
        allow(p2).to receive(:shortcuts) { nil }
        
        expected = { a: 1, b: 2 }
        expect(@manager.shortcuts).to eq expected
      end
    end
    
    describe :sorted_plugins do
      it "should sort custom first and others by abc" do
        p1 = double('penguin')
        p2 = double('custom')
        p3 = double('armadillo')
        allow(p1).to receive(:name) { "AresMUSH::Penguin" }
        allow(p2).to receive(:name) { "AresMUSH::Custom" }
        allow(p3).to receive(:name) { "AresMUSH::Armadillo" }
        expect(@manager).to receive(:plugins) { [ p1, p2, p3 ]}
        
        expect(@manager.sorted_plugins).to eq [ p2, p3, p1 ]
      end
    end
    
  end
end

