$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe HelpReader do

    describe :help_path do 
      it "should be the game dir plus the help dir" do
        AresMUSH.stub(:game_path) { "game" }
        HelpReader.help_path.should eq File.join("game", "help")
      end
    end

    describe :help_files do 
      it "searches for files in the config dir" do
        AresMUSH.stub(:game_path) { "game" }
        Dir.should_receive(:[]).with(File.join("game", "help", "**")) { ["a", "b"]}
        HelpReader.help_files.should eq ["a", "b"]
      end
    end
    

    describe :read do 
      before do
        @reader = HelpReader.new
        HelpReader.stub(:help_files) { ["a", "b"] }
        PluginManager.should_receive(:help_files) { [ "c", "d" ]}        
      end
      
      it "should read the main and plugin help" do        
        parsed1 = { "c" => "d" }
        parsed2 = { "e" => "f" }
        
        # The first {} is what makes sure the prior config was erased
        YamlFileParser.should_receive(:read).with( ["a", "b"],  {} ) { parsed1 }
        YamlFileParser.should_receive(:read).with( ["c", "d"],  parsed1 ) { parsed2 }
        @reader.read 
        @reader.help.should eq parsed2
      end      
    end
    
    describe :categories do
      it "should read the categories from the config mgr" do
        Global.stub(:config) { {"help" => { "categories" => [ "a", "b" ] } } }
        @reader = HelpReader.new
        @reader.categories.should eq [ "a", "b" ]
      end
    end
    
  end
end