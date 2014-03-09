module AresMUSH
  module HelpSystem
    describe Help do
      
      before do
        @reader = double
        Global.stub(:help_reader) { @reader }
        @reader.stub(:categories) { { "a" => { "title" => "a help", "command" => "help" }, "b" => { "title" => "b help", "command" => "bhelp" } } }
      end
    
      describe :valid_commands do
        it "should enumerate the help indices with their prefixes" do
          HelpSystem.valid_commands.should eq [ "help", "bhelp" ]
        end
      end
      
      describe :category_for_command do
        it "should return the category if found" do
          HelpSystem.category_for_command("bhelp").should eq "b"
        end
        
        it "should return nil if not found" do
          HelpSystem.category_for_command("xhelp").should be_nil
        end
      end
      
      describe :category_title do
        it "should return the category title if found" do
          HelpSystem.category_title("b").should eq "b help"
        end
        
        it "should return empty if not found" do
          HelpSystem.category_title("x").should be_empty
        end
      end
      
      describe :find_help do
        before do
          Global.stub(:help) {{ "a" => { "a topic" => "a topic text", "b topic" => "b topic text" }}}
        end
        
        it "should search the help ignoring case" do
          HelpSystem.find_help("a", "A TOPic").should eq "a topic text"
        end
        
        it "should return nil if no topic found" do
          HelpSystem.find_help("a", "xyz").should be_nil
        end
      end
      
      describe :search_topics do
        before do
          Global.stub(:help) {{ "a" => { "a topic" => "a topic text", "b topic" => "b topic text" }}}
        end
        
        it "should return topics containing the keyword" do
          HelpSystem.search_topics("a", "topic").should eq [ "A Topic", "B Topic" ]
        end
        
        it "should return empty list if nothing found" do
          HelpSystem.search_topics("a", "foo").should eq []
        end
      end
    end
  end
end