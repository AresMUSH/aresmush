$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe AddonManager do

    before do
      @temp_dir = "#{Dir.pwd}/tmp_addon"
      FileUtils.rm_rf @temp_dir
      Dir.mkdir @temp_dir
      Dir.mkdir File.join(@temp_dir, "addons")
      create_fake_class("a", "\"foo\"")
      create_fake_class("b", "\"bar\"")

      @factory = double(AddonFactory)
      @manager = AddonManager.new(@factory, @temp_dir)
    end

    after do
      FileUtils.rm_rf @temp_dir
    end

    describe :load_all do
      it "loads addon A" do
        @factory.should_receive(:create_addon_classes)
        @manager.load_all
        a = SystemTest_a.new
        a.test.should eq "foo"
      end

      it "loads addon B" do
        @factory.should_receive(:create_addon_classes)
        @manager.load_all
        b = SystemTest_b.new
        b.test.should eq "bar"
      end
      
      it "can reload a addon that's changed" do
        @factory.should_receive(:create_addon_classes).twice
        @manager.load_all
        # Now change the class
        create_fake_class("a", "\"baz\"")
        @manager.load_all
        a = SystemTest_a.new
        a.test.should eq "baz"
      end
    end

    describe :load_addon do
      it "loads a single addon" do
        @factory.should_receive(:create_addon_classes)
        @manager.load_addon("a")
        a = SystemTest_a.new
        a.test.should eq "foo"
      end

      it "raises an error if the addon is not found" do
        expect{@manager.load_addon("x")}.to raise_error(SystemNotFoundException)
      end

      it "catches syntax errors" do 
        create_fake_class("a", "end")
        expect{@manager.load_addon("a")}.to raise_error(SyntaxError)
      end
      
      it "can reload a addon that's changed" do
        @factory.should_receive(:create_addon_classes).twice
        @manager.load_addon("a")
        # Now change the class
        create_fake_class("a", "\"baz\"")
        @manager.load_addon("a")
        a = SystemTest_a.new
        a.test.should eq "baz"
      end
    end

    def create_fake_class(name, ret_val)
      addon_dir = File.join(@temp_dir, "addons", name)
      FileUtils.rm_rf addon_dir
      Dir.mkdir addon_dir
      File.open("#{@temp_dir}/addons/#{name}/#{name}.rb", "w") do |f| 
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

