

require "aresmush"

module AresMUSH

  describe LocaleLoader do
    describe :load_dir do
      it "should do nothing if the dir doesn't exist" do
        allow(Dir).to receive(:exist?).with("dir") { false }
        expect(LocaleLoader).to_not receive(:load_file)
        LocaleLoader.load_dir("dir")
      end
      
      it "should load each file in the dir" do
        allow(Dir).to receive(:exist?).with("dir") { true }
        allow(Dir).to receive(:foreach).with("dir").and_yield("a").and_yield("b")
        expect(LocaleLoader).to receive(:load_file).with(File.join("dir", "a"))
        expect(LocaleLoader).to receive(:load_file).with(File.join("dir", "b"))
        LocaleLoader.load_dir("dir")
      end
    end
    
    describe :load_files do
      it "should load each file" do
        expect(LocaleLoader).to receive(:load_file).with("f1")
        expect(LocaleLoader).to receive(:load_file).with("f2")        
        LocaleLoader.load_files(["f1", "f2"])
      end
    end
    
    describe :load_file do
      it "should do nothing if the file is a directory" do
        allow(File).to receive(:directory?).with("f") { true }
        expect(I18n.load_path).to_not receive(:<<).with("f")
        LocaleLoader.load_file("f")
      end

      it "should pass along a regular file to the backend" do
        allow(AresLogger).to receive(:create_log_dir) {} 
        allow(File).to receive(:directory?).with("f") { false }
        expect(I18n.load_path).to receive(:<<).with("f")
        LocaleLoader.load_file("f")
      end
    end
  end
end

