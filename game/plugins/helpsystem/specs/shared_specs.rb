module AresMUSH
  module HelpSystem
    describe HelpSystem do
      
      before do
        @reader = double
        HelpSystem.stub(:categories) { 
          { 
                "a" => 
                { "title" => "a help", 
                  "command" => "help",
                  "topics" => { "a topic" => "a.txt", "b topic" => "b.txt" }
                },
                "b" => 
                { "title" => "b help", 
                  "command" => "bhelp"
                },
              }
        } # end stub
      end
    
      describe :category do
        it "should return a category by name" do
          hash = { "title" => "b help", "command" => "bhelp" }
          HelpSystem.category("b").should eq hash
        end
      end
      
      describe :topics do
        it "should return a topic by name" do
          hash = { "a topic" => "a.txt", "b topic" => "b.txt" }
          HelpSystem.topics("a").should eq hash
        end
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
        it "should search the help ignoring case and read the file" do
          File.should_receive(:read).with("a.txt") { "a topic text" }
          HelpSystem.find_help("a", "A TOPic").should eq "a topic text"
        end
        
        it "should return nil if no topic found" do
          HelpSystem.find_help("a", "xyz").should be_nil
        end
      end
      
      describe :search_topics do
        it "should return topic names matching the keyword" do
          HelpSystem.search_topics("a", "topic").should eq [ "A Topic", "B Topic" ]
        end
        
        it "should return empty list if nothing found" do
          HelpSystem.search_topics("a", "foo").should eq []
        end
      end
    end
  end
end