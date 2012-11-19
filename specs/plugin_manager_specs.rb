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
      @manager = PluginManager.new(@factory, @temp_dir)
    end

    after do
      FileUtils.rm_rf @temp_dir
    end

    describe :load_all do
      it "loads plugin A" do
        @factory.should_receive(:create_plugin_classes)
        @manager.load_all
        a = SystemTest_a.new
        a.test.should eq "foo"
      end

      it "loads plugin B" do
        @factory.should_receive(:create_plugin_classes)
        @manager.load_all
        b = SystemTest_b.new
        b.test.should eq "bar"
      end
      
      it "can reload a plugin that's changed" do
        @factory.should_receive(:create_plugin_classes).twice
        @manager.load_all
        # Now change the class
        create_fake_class("a", "\"baz\"")
        @manager.load_all
        a = SystemTest_a.new
        a.test.should eq "baz"
      end
    end

    describe :load_plugin do
      it "loads a single plugin" do
        @factory.should_receive(:create_plugin_classes)
        @manager.load_plugin("a")
        a = SystemTest_a.new
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
        a = SystemTest_a.new
        a.test.should eq "baz"
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
        f.write "class SystemTest_#{name}\n"
        f.write "def test\n"
        f.write "#{ret_val}\n"
        f.write "end\n"
        f.write "end\n"
        f.write "end\n"
      end
    end

  end
end

