module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        Global.stub(:read_config).with("fs3skills", "max_luck") { 3 }
        SpecHelpers.stub_translate_for_testing
      end

      describe :parse_and_roll do
        before do
          @client = double
          @char = double
        end
  
        it "should emit failure and return nil if it can't parse the roll" do
          FS3Skills.stub(:parse_roll_params) { nil }
          @client.should_receive(:emit_failure).with 'fs3skills.unknown_roll_params'
          FS3Skills.parse_and_roll(@client, @char, "x").should be_nil
        end
  
        it "should return a die result for a plain number" do
          # Note - automatically factors in a default linked attr and die multiplier
          FS3Skills.stub(:roll_dice).with(5) { [1, 2, 3, 4, 5] }
          FS3Skills.parse_and_roll(@client, @char, "2").should eq [1, 2, 3, 4, 5]
        end
  
        it "should parse results and roll the ability for any other string" do
          FS3Skills.stub(:parse_roll_params) { "x" }
          FS3Skills.stub(:roll_ability).with(@client, @char, "x") { [1, 2, 3]}
          FS3Skills.parse_and_roll(@client, @char, "abc").should eq [1, 2, 3]
        end
      end

      describe :can_parse_roll_params do
        it "should handle attribute by itself" do
          params = FS3Skills.parse_roll_params("A")
          check_params(params, "A", 0, nil)
        end
        
        it "should handle abiliity and positive modifier" do
          params = FS3Skills.parse_roll_params("A+22")
          check_params(params, "A", 22, nil)
        end

        it "should handle abiliity and positive modifier" do
          params = FS3Skills.parse_roll_params("A+22")
          check_params(params, "A", 22, nil)
        end

        it "should handle abiliity and negative modifier" do
          params = FS3Skills.parse_roll_params("A-3")
          check_params(params, "A", -3, nil)
        end
        
        it "should handle ability with space" do
          params = FS3Skills.parse_roll_params("A B")
          check_params(params, "A B", 0, nil)
        end
        
        it "should handle ability with modifier and space" do
          params = FS3Skills.parse_roll_params("A B + 3")
          check_params(params, "A B", 3, nil)
        end

        it "should handle ability with modifier and linked attr and space" do
          params = FS3Skills.parse_roll_params("A B + C D + 3")
          check_params(params, "A B", 3, "C D")
        end
        
        it "should handle ability and linked attr" do
          params = FS3Skills.parse_roll_params("A+B")
          check_params(params, "A", 0, "B")
        end

        it "should handle ability and linked attr and modifier" do
          params = FS3Skills.parse_roll_params("A+B-2")
          check_params(params, "A", -2, "B")
        end
        
        it "should handle bad string with negative ruling attr" do
          params = FS3Skills.parse_roll_params("A-B+2")
          params.should be_nil
        end

        it "should handle bad string with a non-digit modifier" do
          params = FS3Skills.parse_roll_params("A+B+C")
          params.should be_nil
        end
        
        it "should handle bad string with too many params" do
          params = FS3Skills.parse_roll_params("A+B+2+D")
          params.should be_nil
        end
      end
      
      describe :dice_to_roll_for_ability do
        before do
          @char = double
          @char.stub(:name) { "Nemo" }

          FS3Skills.stub(:get_ability_type).with("Firearms") { :action }
          FS3Skills.stub(:get_ability_type).with("Brawn") { :attribute }
          FS3Skills.stub(:get_ability_type).with("Reflexes") { :attribute }
          FS3Skills.stub(:get_ability_type).with("English") { :language }
          FS3Skills.stub(:get_ability_type).with("Basketweaving") { :background }
          FS3Skills.stub(:get_ability_type).with("Untrained") { :background }
          FS3Skills.stub(:get_ability_type).with(nil) { :background }
          
          FS3Skills.stub(:ability_rating).with(@char, "Untrained") { 0 }
          FS3Skills.stub(:ability_rating).with(@char, "Firearms") { 1 }
          FS3Skills.stub(:ability_rating).with(@char, "Basketweaving") { 2 }
          FS3Skills.stub(:ability_rating).with(@char, "English") { 3 }
          FS3Skills.stub(:ability_rating).with(@char, "Brawn") { 4 }
          FS3Skills.stub(:ability_rating).with(@char, "Reflexes") { 2 }
          
          FS3Skills.stub(:get_linked_attr).with("Untrained") { "Brawn" }
          FS3Skills.stub(:get_linked_attr).with("Firearms") { "Reflexes" }
          FS3Skills.stub(:get_linked_attr).with("Brawn") { nil }
          FS3Skills.stub(:get_linked_attr).with("Basketweaving") { "Reflexes" }
          FS3Skills.stub(:get_linked_attr).with("English") { "Reflexes" }
        end
      
        it "should roll ability alone" do
          roll_params = RollParams.new("Firearms")
          # Rolls Firearms + Reflexes 
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 3
        end
      
        it "should roll ability + a different ruling attr" do
          roll_params = RollParams.new("Firearms", 0, "Brawn")
          # Rolls Firearms + Brawn
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 5
        end
        
        it "should roll attr + ability" do
          roll_params = RollParams.new("Brawn", 0, "Firearms")
          # Rolls Brawn + Firearms
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 5
        end

        it "should roll attr + attr" do
          roll_params = RollParams.new("Brawn", 0, "Reflexes")
          # Rolls Brawn + Reflexes
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 6
        end
        
        it "should roll ability + ability" do
          roll_params = RollParams.new("Firearms", 0, "Firearms")
          # Rolls Firearms + Firearms
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 2
        end
        
        it "should roll twice a background skill" do 
          roll_params = RollParams.new("Basketweaving")
          # Rolls Basketweaving*2 + Reflexes
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 6
        end
        
        it "should roll twice a language skill" do 
          roll_params = RollParams.new("English")
          # Rolls English*2 + Reflexes
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 8
        end
        
        it "should roll ability + modifier" do
          roll_params = RollParams.new("Firearms", 1)
          # Rolls Firearms + Reflexes + 1
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 4
        end
      
        it "should roll ability - modifier" do
          roll_params = RollParams.new("Firearms", -1)
          # Rolls Firearms + Reflexes - 1 
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 2
        end
      
        it "should roll ability + ruling attr + modifier" do
          roll_params = RollParams.new("Firearms", 3, "Brawn")
          # Rolls Firearms + Brawn + 3 
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 8
        end
        
        it "should roll everyman for an attribute" do
          roll_params = RollParams.new("Brawn")
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 5
        end
        
        it "should roll everyman for nonexistant bg skill" do
          roll_params = RollParams.new("Untrained")
          # Rolls everyman (1) + Brawn
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 5
        end
        
        it "should roll zero for nonexistant lang skill" do
          FS3Skills.stub(:ability_rating).with(@char, "English") { 0 }
          roll_params = RollParams.new("English")
          # Rolls 0 + Reflexes
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 2
        end
        
      end
      
      def check_params(params, ability, modifier, linked_attr)
        params.ability.should eq ability
        params.modifier.should eq modifier
        params.linked_attr.should eq linked_attr
      end
      
      
    end
  end
end