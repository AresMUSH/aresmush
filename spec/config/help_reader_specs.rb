$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe HelpReader do

    before do
      @markdown = double
      @help_data = { "topic" => "a", "plugin" => "x", "path" => "p", "b" => "c" }
      @markdown.stub(:metadata) { @help_data } 
      @markdown.stub(:contents) { "contents" }
      @markdown.stub(:load_file)
      MarkdownFile.stub(:new) { @markdown }
      @reader = HelpReader.new     
    end
    
    describe :load_help_file do 
      it "should load the metadata" do
        MarkdownFile.should_receive(:new).with("file") { @markdown }
        @reader.load_help_file("file")
        @reader.help["file"]["b"].should eq "c"
      end
    end
    
    describe :unload_help do
      it "should remove the help topic" do
        other_help = { "topic" => "a", "plugin" => "y", "path" => "p", "b" => "c" } 
        @reader.help["a"] = @help_data
        @reader.help["b"] = other_help
        
        @reader.unload_help("x")
        @reader.help["a"].should be_nil
        @reader.help["b"].should eq other_help
      end
      
    end
    
  end
end