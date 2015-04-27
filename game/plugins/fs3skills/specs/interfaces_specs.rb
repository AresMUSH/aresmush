module AresMUSH
  module FS3Skills
    describe FS3Skills do 
      
      before do
        # Note:  By seeding the random number generator, we can avoid the randomness.
        #   If you use Kernel.srand(22), the first 10 die rolls in tests will always be:  
        #      [6, 5, 5, 1, 5, 7, 7, 4, 5, 1]
        Kernel.srand 22
        Global.stub(:config) {
          {
            "fs3skills" => {
              "attributes" => [ { "name" => "Mind" }, {"name" => "Body" } ],
              "action_skills" => [ { "name" => "Firearms", "ruling_attr" => "Reaction" } ],
              "default_ruling_attr" => "Mind"
            }
          }
        }
        
        SpecHelpers.stub_translate_for_testing        
        
        @char = double      
      end
    
      describe :roll_ability do
        before do
          @client = double
          @char.stub(:name) { "Nemo" }
          
          FS3Skills.stub(:ability_rating).with(@char, "Firearms") { 2 }
          FS3Skills.stub(:ability_rating).with(@char, "Reaction") { 3 }
          FS3Skills.stub(:ability_rating).with(@char, "Mind") { 1 }
          FS3Skills.stub(:ability_rating).with(@char, "Unskilled") { 0 }
          FS3Skills.stub(:get_ruling_attr).with(@char, "Firearms") { "Reaction" }
        end
        
        it "should roll ability alone" do
          roll_params = RollParams.new("Firearms")
          # Rolls Firearms + Reaction --> 5 dice
          FS3Skills.roll_ability(@client, @char, roll_params).should eq [6, 5, 5, 1, 5]
        end
        
        it "should roll ability + ruling attr" do
          roll_params = RollParams.new("Firearms", 0, "Mind")
          # Rolls Firearms + Mind --> 3 dice
          FS3Skills.roll_ability(@client, @char, roll_params).should eq [6, 5, 5]
        end
        
        it "should roll ability + modifier" do
          roll_params = RollParams.new("Firearms", 1)
          # Rolls Firearms + Reaction + 1 --> 6 dice
          FS3Skills.roll_ability(@client, @char, roll_params).should eq [6, 5, 5, 1, 5, 7]
        end
        
        it "should roll ability - modifier" do
          roll_params = RollParams.new("Firearms", -1)
          # Rolls Firearms + Reaction - 1 --> 4 die
          FS3Skills.roll_ability(@client, @char, roll_params).should eq [6, 5, 5, 1]
        end
        
        it "should roll ability + ruling attr + modifier" do
          roll_params = RollParams.new("Firearms", 3, "Mind")
          # Rolls Firearms + Mind + 3 --> 6 dice
          FS3Skills.roll_ability(@client, @char, roll_params).should eq [6, 5, 5, 1, 5, 7]
        end
        
        it "should confirm if rolling 0-rated skill" do
          roll_params = RollParams.new("Unskilled", 0, "Mind")
          # Rolls Unskilled + Mind --> 1 die
          @client.should_receive(:emit_ooc).with('fs3skills.confirm_zero_skill')
          FS3Skills.roll_ability(@client, @char, roll_params).should eq [6]
        end
      end
    
      describe :roll_dice do
        it "should roll the specified number of dice" do
          FS3Skills.roll_dice(4).should eq [ 6, 5, 5, 1 ]
        end
        
        it "should always roll 1 die even if asked for 0 or less" do
          FS3Skills.roll_dice(0).should eq [6]
        end
        
        it "should not allow giant die rolls" do
          FS3Skills.roll_dice(99).should eq [7, 7, 7, 7, 7, 7]
        end
      end
    
      describe :get_success_level do
        it "should return number of successes if there are any" do
          FS3Skills.get_success_level([7, 1, 3, 8]).should eq 2
        end
        
        it "should return a botch if there are more than two ones and no successes" do
          FS3Skills.get_success_level([4, 1, 1, 1]).should eq -1
        end
        
        it "should return a failure if there are no successes but less than two ones." do
          FS3Skills.get_success_level([4, 1, 3, 2]).should eq 0
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
        it "should return the ability rating" do
          FS3Skills.stub(:get_ability).with(@char, "Basketweaving") { { "rating" => 3 } }
          FS3Skills.ability_rating(@char, "Basketweaving").should eq 3
        end
        
        it "should return nil if no skill" do
          FS3Skills.stub(:get_ability).with(@char, "Basketweaving") { nil }
          FS3Skills.ability_rating(@char, "Basketweaving").should eq 0
        end
      end
    
      describe :get_ruling_attr do
        it "should return the configured attr for an action skill" do         
          FS3Skills.get_ruling_attr(@char, "Firearms").should eq "Reaction"
        end
      
        it "should return the attr itself for an attr" do
          FS3Skills.get_ruling_attr(@char, "Body").should eq "Body"
        end

        context "background skills" do
          it "should return the default if the char doesn't have skill" do
            FS3Skills.stub(:get_ability).with(@char, "Basketweaving") { nil }
            FS3Skills.get_ruling_attr(@char, "Basketweaving").should eq "Mind"        
          end
      
          it "should return the default if the skill has no ruling attr" do
            FS3Skills.stub(:get_ability).with(@char, "Basketweaving") { {} }
            FS3Skills.get_ruling_attr(@char, "Basketweaving").should eq "Mind"        
          end
      
          it "should return the configured ruling attr if there is one" do
            FS3Skills.stub(:get_ability).with(@char, "Basketweaving") { { "ruling_attr" => "Body" } }
            FS3Skills.get_ruling_attr(@char, "Basketweaving").should eq "Body"
          end
        end
      end
    
      describe :print_skill_rating do
        it "should print a novice rating" do
          FS3Skills.print_skill_rating(1).should eq "%xg@%xn"
        end
      
        it "should print a pro rating" do
          FS3Skills.print_skill_rating(4).should eq "%xg@@@%xn%xy@%xn"
        end
      
        it "should print a vet rating" do
          FS3Skills.print_skill_rating(7).should eq "%xg@@@%xn%xy@@@%xn%xr@%xn"
        end
      
        it "should print a master rating" do
          FS3Skills.print_skill_rating(12).should eq "%xg@@@%xn%xy@@@%xn%xr@@@%xn%xb@@@%xn"
        end
      end
    end
  end
end