module AresMUSH
  module FS3Skills
    describe FS3Skills do 
      
      before do
        # Note:  By seeding the random number generator, we can avoid the randomness.
        #   If you use Kernel.srand(22), the first 10 die rolls in tests will always be:  
        #      [6, 5, 1, 5, 7, 7, 4, 5, 1]
        Kernel.srand 22

        Global.stub(:read_config).with("fs3skills", "aptitudes") { [ { "name" => "Mind" }, {"name" => "Body" } ] }
        Global.stub(:read_config).with("fs3skills", "action_skills") { [ { "name" => "Firearms", "linked_attr" => "Reaction" } ] }
        Global.stub(:read_config).with("fs3skills", "default_linked_attr") { "Mind" }
        Global.stub(:read_config).with("fs3skills", "advantages") { [{ "name" => "Wealth" }] }
        
        SpecHelpers.stub_translate_for_testing        
        
        @char = double  
        @char.stub(:fs3_expertise) { [] }
        @char.stub(:fs3_interests) { [] }
            
      end
    
      describe :roll_ability do
        before do
          @client = double
          @char.stub(:name) { "Nemo" }
        end
        
        it "should roll ability" do
          roll_params = RollParams.new("Firearms")
          FS3Skills.should_receive(:dice_to_roll_for_ability).with(@char, roll_params) { 5 }
          FS3Skills.roll_ability(@client, @char, roll_params).should eq [6, 5, 1, 5, 7]
        end
                
        it "should confirm if rolling 0-rated skill" do
          roll_params = RollParams.new("Unskilled", 0, "Mind")
          FS3Skills.should_receive(:dice_to_roll_for_ability).with(@char, roll_params) { 0 }
          @client.should_receive(:emit_ooc).with('fs3skills.confirm_zero_skill')
          FS3Skills.roll_ability(@client, @char, roll_params).should eq [6]
        end
      end
    
      describe :roll_dice do
        it "should roll the specified number of dice" do
          FS3Skills.roll_dice(4).should eq [ 6, 5, 1, 5 ]
        end
        
        it "should always roll 1 die even if asked for 0 or less" do
          FS3Skills.roll_dice(0).should eq [6]
        end
        
        it "should not allow giant die rolls" do
          FS3Skills.roll_dice(99).should eq [9, 9, 9, 9, 9, 9]
        end
      end
    
      describe :get_success_level do
        it "should return number of successes if there are any" do
          FS3Skills.get_success_level([7, 1, 3, 8]).should eq 1
        end
        
        it "should return a botch if there are more than two ones and no successes" do
          FS3Skills.get_success_level([4, 1, 1, 1]).should eq -1
        end
        
        it "should return a failure if there are no successes but less than two ones." do
          FS3Skills.get_success_level([4, 1, 3, 7]).should eq 0
        end
      end
    
      describe :opposed_result_title do
        it "should handle the first person winning" do
          AresMUSH::Locale.stub(:translate).with("fs3skills.opposed_victory", { :name => "Bob" }) { "bob wins" }        
          FS3Skills.opposed_result_title("Bob", 3, "Harvey", 0).should eq 'bob wins'
        end
        
        it "should handle the second person winning" do
          AresMUSH::Locale.stub(:translate).with("fs3skills.opposed_marginal_victory", { :name => "Harvey" }) { "harvey wins" }        
          FS3Skills.opposed_result_title("Bob", 1, "Harvey", 2).should eq 'harvey wins'
        end
        
        it "should handle a draw" do
          FS3Skills.opposed_result_title("Bob", 1, "Harvey", 1).should eq 'fs3skills.opposed_draw'
        end
        
        it "should handle both failing" do
          FS3Skills.opposed_result_title("Bob", 0, "Harvey", -1).should eq 'fs3skills.opposed_both_fail'
        end
      end
    
      describe :ability_rating do
        
        it "should return the ability rating for an action skill" do
          @char.stub(:fs3_action_skills) { { "Firearms" => 3 } }
          FS3Skills.ability_rating(@char, "Firearms").should eq 3
        end

        it "should return the ability rating for an advantage" do
          @char.stub(:fs3_advantages) { { "Wealth" => 4 } }
          FS3Skills.ability_rating(@char, "Wealth").should eq 4
        end
        
        it "should return 4 for an expertise" do
          @char.stub(:fs3_expertise) { [ "Basketweaving" ] }
          FS3Skills.ability_rating(@char, "Basketweaving").should eq 4
        end
        
        it "should return 2 for an interest" do
          @char.stub(:fs3_interests) { [ "Basketweaving" ] }
          FS3Skills.ability_rating(@char, "Basketweaving").should eq 2
        end
        
        it "should return the aptitude rating for an aptitude" do
          @char.stub(:fs3_aptitudes) { { "Mind" => 2 } }
          FS3Skills.ability_rating(@char, "Mind").should eq 2
        end
        
        it "should return 0 if no skill" do
          @char.stub(:fs3_aptitudes) { { "Mind" => 2 } }
          FS3Skills.ability_rating(@char, "Basketweaving").should eq 0
        end
      end
    
      describe :get_linked_attr do
        before do 
          @char.stub(:fs3_linked_attrs) { {} }
        end
        
        it "should return the configured attr for an action skill" do         
          FS3Skills.get_linked_attr(@char, "Firearms").should eq "Reaction"
        end
      
        it "should return the aptitude itself for an aptitude" do
          FS3Skills.get_linked_attr(@char, "Body").should eq "Body"
        end
        
        context "interests" do
          before do 
            @char.stub(:fs3_interests) { [ "Basketweaving" ] }
          end
          
          it "should return the default if the skill has no ruling attr" do
            FS3Skills.get_linked_attr(@char, "Basketweaving").should eq "Mind"        
          end
      
          it "should return the configured ruling attr if there is one" do
            @char.stub(:fs3_linked_attrs) { { "Basketweaving" => "Body" } }
            FS3Skills.get_linked_attr(@char, "Basketweaving").should eq "Body"
          end
        end
      end
    end
  end
end