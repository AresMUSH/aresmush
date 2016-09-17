$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe PluginManager do

    before do
      @temp_dir = "#{Dir.pwd}/tmp_plugin"      
      FileUtils.rm_rf @temp_dir
      Dir.mkdir @temp_dir
      Dir.mkdir File.join(@temp_dir, "plugins")

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
    
    describe :locale_files do
      it "should find all the locale files in the plugin locale dirs" do
       PluginManager.stub(:plugin_path) { "plugins" }
       search = File.join("plugins", "**", "locale*.yml")
       files = []
       Dir.should_receive(:[]).with(search) { files}
       PluginManager.locale_files.should eq files
      end
    end
    
    describe :help_files do
      it "should find all the help files in the plugin config dirs" do
       PluginManager.stub(:plugin_path) { "plugins" }
       search = File.join("plugins", "*", "help", "**", "*.md")
       files = [ "a", "b" ]
       Dir.should_receive(:[]).with(search) { files }
       PluginManager.help_files.should eq [ "a", "b" ]
      end
    end    
  end
end

