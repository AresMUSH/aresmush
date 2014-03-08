module AresMUSH
  module Help
    describe Help do
      
      before do
        @reader = double
        Global.stub(:help_reader) { @reader }
        @reader.stub(:categories) { { "a" => { "title" => "a help", "command" => "help" }, "b" => { "title" => "b help", "command" => "bhelp" } } }
      end
    
      describe :valid_commands do
        it "should enumerate the help indices with their prefixes" do
          Help.valid_commands.should eq [ "help", "bhelp" ]
        end
      end
      
      describe :category_for_command do
        it "should return the category if found" do
          Help.category_for_command("bhelp").should eq "b"
        end
        
        it "should return nil if not found" do
          Help.category_for_command("xhelp").should be_nil
        end
      end
      
      describe :category_title do
        it "should return the category title if found" do
          Help.category_title("b").should eq "b help"
        end
        
        it "should return empty if not found" do
          Help.category_title("x").should be_empty
        end
      end
    end
  end
end