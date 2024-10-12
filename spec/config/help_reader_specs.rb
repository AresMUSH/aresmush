

require "aresmush"

module AresMUSH

  describe HelpReader do

    before do
      @markdown = double
      @help_data = { "toc" => "c", "aliases" => [ "x" ] }
      allow(@markdown).to receive(:metadata) { @help_data } 
      allow(@markdown).to receive(:contents) { "contents" }
      allow(@markdown).to receive(:load_file)
      allow(MarkdownFile).to receive(:new) { @markdown }
      @reader = HelpReader.new     
    end
    
    describe :load_help_file do 
      it "should load the metadata" do
        expect(MarkdownFile).to receive(:new).with("file") { @markdown }
        @reader.load_help_file("file", "Plugin")
        expect(@reader.help_file_index["file"]["toc"]).to eq "c"
      end
      
      it "should set the plugin and path" do
        allow(MarkdownFile).to receive(:new).with("file") { @markdown }
        @reader.load_help_file("file", "Plugin")
        expect(@reader.help_file_index["file"]["path"]).to eq "file"
        expect(@reader.help_file_index["file"]["plugin"]).to eq "plugin"
      end
      
      it "should set the toc" do
        expect(MarkdownFile).to receive(:new).with("file") { @markdown }
        @reader.load_help_file("file", "Plugin")
        expect(@reader.help_toc["c"]).to eq [ "file" ]
      end
      
      it "should set the keys" do
        expect(MarkdownFile).to receive(:new).with("file") { @markdown }
        @reader.load_help_file("file", "Plugin")
        expect(@reader.help_keys["x"]).to eq "file"
        expect(@reader.help_keys["file"]).to eq "file"
        expect(@reader.help_keys["files"]).to eq "file"
      end
      
      it "should set the contents" do
        expect(MarkdownFile).to receive(:new).with("file") { @markdown }
        @reader.load_help_file("file", "Plugin")
        expect(@reader.help_text["file"]).to eq "contents"
      end
    end
    
    describe :unload_help do
      it "should remove the help topic" do
        xhelp = { "toc" => "a", "plugin" => "x" } 
        yhelp = { "toc" => "b", "plugin" => "y" } 
        @reader.help_file_index["a"] = xhelp
        @reader.help_file_index["b"] = yhelp
        
        @reader.unload_help("x")
        expect(@reader.help_file_index["a"]).to be_nil
        expect(@reader.help_file_index["b"]).to eq yhelp
      end
      
    end
    
  end
end
