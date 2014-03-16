module AresMUSH
  module HelpSystem
    describe HelpSystem do
      
      before do
        @reader = double
        @categories = { 
            "a" => 
            { "title" => "a help", 
              "command" => "help",
              "topics" => { 
                "a topic" => 
                {
                  "file" => "a.txt",
                  "aliases" => [ "x" ]
                }, 
                "b topic" => 
                {
                  "file" => "b.txt"
                },
              }
            },
            "b" => 
              { "title" => "b help", 
                "command" => "bhelp"
              },
            }
        HelpSystem.stub(:categories) {  @categories } # end stub
        end
    
        describe :category do
          it "should return a category by name" do
            HelpSystem.category("b").should eq @categories["b"]
          end
        end
      
        describe :topics do
          it "should return topics for the category" do
            HelpSystem.topics("a").keys.count.should eq 2
            HelpSystem.topics("a").keys[0].should eq "a topic"
            HelpSystem.topics("a").keys[1].should eq "b topic"
          end
        end
      
        describe :topic do
          it "should return a topic by name" do
            HelpSystem.topic("a", "a topic").should eq @categories["a"]["topics"]["a topic"]
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
      
        describe :lookup_alias do
          it "should return nil if no alias found" do
            HelpSystem.lookup_alias("a", "y").should be_nil
          end
        
          it "should return the topic with a matching alias" do
            HelpSystem.lookup_alias("a", "x").should eq "a topic"
          end

          it "should match aliases irrespective of case" do
            HelpSystem.lookup_alias("a", "X").should eq "a topic"
          end
        end
      
        describe :search_help do
          it "should search the help ignoring case" do
            HelpSystem.search_help("a", "TOPic").should eq [ "A Topic", "B Topic" ]
          end
          
          it "should return empty if no matches" do
            HelpSystem.search_help("a", "xyz").should eq []
          end
        end
        
        describe :load_help do
          it "should read the file" do
            File.should_receive(:read).with("a.txt") { "a topic text" }
            HelpSystem.load_help("a", "a topic").should eq "a topic text"
          end
        
          it "should return nil if no topic found" do
            HelpSystem.load_help("a", "xyz").should be_nil
          end
        end
      end
    end
  end