$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe HelpReader do

    before do
      @markdown = double
      @help_data = { "toc" => "c", "aliases" => [ "x" ] }
      @markdown.stub(:metadata) { @help_data } 
      @markdown.stub(:contents) { "contents" }
      @markdown.stub(:load_file)
      MarkdownFile.stub(:new) { @markdown }
      @reader = HelpReader.new     
    end
    
    describe :load_help_file do 
      it "should load the metadata" do
        MarkdownFile.should_receive(:new).with("file") { @markdown }
        @reader.load_help_file("file", "Plugin")
        @reader.help_file_index["file"]["toc"].should eq "c"
      end
      
      it "should set the plugin and path" do
        MarkdownFile.stub(:new).with("file") { @markdown }
        @reader.load_help_file("file", "Plugin")
        @reader.help_file_index["file"]["path"].should eq "file"
        @reader.help_file_index["file"]["plugin"].should eq "plugin"
      end
      
      it "should set the toc" do
        MarkdownFile.should_receive(:new).with("file") { @markdown }
        @reader.load_help_file("file", "Plugin")
        @reader.help_toc["c"].should eq [ "file" ]
      end
      
      it "should set the keys" do
        MarkdownFile.should_receive(:new).with("file") { @markdown }
        @reader.load_help_file("file", "Plugin")
        @reader.help_keys["x"].should eq "file"
        @reader.help_keys["file"].should eq "file"
        @reader.help_keys["files"].should eq "file"
      end
    end
    
    describe :unload_help do
      it "should remove the help topic" do
        xhelp = { "toc" => "a", "plugin" => "x" } 
        yhelp = { "toc" => "b", "plugin" => "y" } 
        @reader.help_file_index["a"] = xhelp
        @reader.help_file_index["b"] = yhelp
        
        @reader.unload_help("x")
        @reader.help_file_index["a"].should be_nil
        @reader.help_file_index["b"].should eq yhelp
      end
      
    end
    
  end
end