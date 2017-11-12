$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe LocaleLoader do
    describe :load_dir do
      it "should do nothing if the dir doesn't exist" do
        Dir.stub(:exist?).with("dir") { false }
        LocaleLoader.should_not_receive(:load_file)
        LocaleLoader.load_dir("dir")
      end
      
      it "should load each file in the dir" do
        Dir.stub(:exist?).with("dir") { true }
        Dir.stub(:foreach).with("dir").and_yield("a").and_yield("b")
        LocaleLoader.should_receive(:load_file).with(File.join("dir", "a"))
        LocaleLoader.should_receive(:load_file).with(File.join("dir", "b"))
        LocaleLoader.load_dir("dir")
      end
    end
    
    describe :load_files do
      it "should load each file" do
        LocaleLoader.should_receive(:load_file).with("f1")
        LocaleLoader.should_receive(:load_file).with("f2")        
        LocaleLoader.load_files(["f1", "f2"])
      end
    end
    
    describe :load_file do
      it "should do nothing if the file is a directory" do
        File.stub(:directory?).with("f") { true }
        I18n.load_path.should_not_receive(:<<).with("f")
        LocaleLoader.load_file("f")
      end

      it "should pass along a regular file to the backend" do
        AresLogger.stub(:create_log_dir) {} 
        File.stub(:directory?).with("f") { false }
        I18n.load_path.should_receive(:<<).with("f")
        LocaleLoader.load_file("f")
      end
    end
  end
end

