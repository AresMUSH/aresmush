$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe PluginManager do

    before do
      @temp_dir = "#{Dir.pwd}/tmp_plugin"      
      FileUtils.rm_rf @temp_dir
      Dir.mkdir @temp_dir
      Dir.mkdir File.join(@temp_dir, "plugins")
      create_fake_class("a", "\"foo\"")
      create_fake_class("b", "\"bar\"")

      @factory = double(PluginFactory)
      AresMUSH.stub(:game_path) { @temp_dir }      
      @manager = PluginManager.new(@factory)
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
    
    describe :locale_files do
      it "should find all the locale files in the plugin locale dirs" do
       PluginManager.stub(:plugin_path) { "plugins" }
       search = File.join("plugins", "**", "locale*.yml")
       files = []
       Dir.should_receive(:[]).with(search) { files}
       PluginManager.locale_files.should eq files
      end
    end
    
    describe :config_files do
      it "should find all the config files in the plugin config dirs" do
       PluginManager.stub(:plugin_path) { "plugins" }
       search = File.join("plugins", "**", "config*.yml")
       files = []
       Dir.should_receive(:[]).with(search) { files}
       PluginManager.config_files.should eq files
      end
    end
    
    describe :plugin_files do
      it "should find all the ruby files in the plugin lib dirs" do
       PluginManager.stub(:plugin_path) { "plugins" }
       search = File.join("plugins", "*", "**", "*.rb")
       files = ["a.rb", "b.rb", "c_spec.rb", "d_specs.rb"]
       Dir.should_receive(:[]).with(search) { files}
       PluginManager.plugin_files.should eq ["a.rb", "b.rb"]
      end
      
      it "should find all the ruby files in a specific plugin's lib dir" do
        PluginManager.stub(:plugin_path) { "plugins" }
        search = File.join("plugins", "foo", "**", "*.rb")
        files = ["a.rb", "b.rb", "c_spec.rb", "d_specs.rb"]
        Dir.should_receive(:[]).with(search) { files}
        PluginManager.plugin_files("foo").should eq ["a.rb", "b.rb"]
      end
    end
    
    describe :load_all do
      it "loads plugin A" do
        @factory.should_receive(:create_plugin_classes)
        @manager.load_all
        a = SystemTestModule_a::SystemTest_a.new
        a.test.should eq "foo"
      end

      it "loads plugin B" do
        @factory.should_receive(:create_plugin_classes)
        @manager.load_all
        b = SystemTestModule_b::SystemTest_b.new
        b.test.should eq "bar"
      end
      
      it "can reload a plugin that's changed" do
        @factory.should_receive(:create_plugin_classes).twice
        @manager.load_all
        # Now change the class
        create_fake_class("a", "\"baz\"")
        @manager.load_all
        a = SystemTestModule_a::SystemTest_a.new
        a.test.should eq "baz"
      end
    end

    describe :load_plugin do
      it "loads a single plugin" do
        @factory.should_receive(:create_plugin_classes)
        @manager.load_plugin("a")
        a = SystemTestModule_a::SystemTest_a.new
        a.test.should eq "foo"
      end

      it "raises an error if the plugin is not found" do
        expect{@manager.load_plugin("x")}.to raise_error(SystemNotFoundException)
      end

      it "catches syntax errors" do 
        create_fake_class("a", "end")
        expect{@manager.load_plugin("a")}.to raise_error(SyntaxError)
      end
      
      it "can reload a plugin that's changed" do
        @factory.should_receive(:create_plugin_classes).twice
        @manager.load_plugin("a")
        # Now change the class
        create_fake_class("a", "\"baz\"")
        @manager.load_plugin("a")
        a = SystemTestModule_a::SystemTest_a.new
        a.test.should eq "baz"
      end
    end
    
    describe :unload_plugin do
      before do
        @factory.stub(:create_plugin_classes) { [@aplugin, @bplugin] }
        @manager.load_all
        @aplugin = SystemTestModule_a::SystemTest_a.new
        @bplugin = SystemTestModule_b::SystemTest_b.new
        @manager.plugins << @aplugin
        @manager.plugins << @bplugin
      end
      
      it "should remove a matching plugin from the loaded list" do
        @manager.unload_plugin("SystemTestModule_a")
        @manager.plugins.should_not include @aplugin
      end
      
      it "should unload the plugin module" do
        @manager.unload_plugin("SystemTestModule_a")
        AresMUSH.constants.should_not include :SystemTestModule_a
      end
      
      it "should throw an error if the plugin doesn't exist" do
        expect{@manager.unload_plugin("x")}.to raise_error(SystemNotFoundException)
      end
    end
        

    def create_fake_class(name, ret_val)
      plugin_dir = File.join(@temp_dir, "plugins", name)
      FileUtils.rm_rf plugin_dir
      Dir.mkdir plugin_dir
      plugin_dir = File.join(plugin_dir, "lib")
      Dir.mkdir plugin_dir
      File.open(File.join(plugin_dir, "#{name}.rb"), "w") do |f| 
        f.write "module AresMUSH\n"
        f.write "module SystemTestModule_#{name}\n"
        f.write "class SystemTest_#{name}\n"
        f.write "def test\n"
        f.write "#{ret_val}\n"
        f.write "end\n"
        f.write "end\n"
        f.write "end\n"
        f.write "end\n"
      end
    end

  end
end

