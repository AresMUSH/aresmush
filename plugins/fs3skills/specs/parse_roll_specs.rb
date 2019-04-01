module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        allow(Global).to receive(:read_config).with("fs3skills", "max_luck") { 3 }
        stub_translate_for_testing
      end

      describe :parse_and_roll do
        before do
          @char = double
        end
  
        it "should emit failure and return nil if it can't parse the roll" do
          allow(FS3Skills).to receive(:parse_roll_params) { nil }
          expect(FS3Skills.parse_and_roll(@char, "x")).to be_nil
        end
  
        it "should return a die result for a plain number" do
          # Note - automatically factors in a default linked attr
          allow(FS3Skills).to receive(:roll_dice).with(4) { [1, 2, 3, 4, 5] }
          expect(FS3Skills.parse_and_roll(@char, "2")).to eq [1, 2, 3, 4, 5]
        end
  
        it "should parse results and roll the ability for any other string" do
          allow(FS3Skills).to receive(:parse_roll_params) { "x" }
          allow(FS3Skills).to receive(:roll_ability).with(@char, "x") { [1, 2, 3]}
          expect(FS3Skills.parse_and_roll(@char, "abc")).to eq [1, 2, 3]
        end
      end

      describe :can_parse_roll_params do
        before do
          allow(FS3Skills).to receive(:get_ability_type) { :action }
        end
        
        it "should handle attribute by itself" do
          allow(FS3Skills).to receive(:get_ability_type).with("A") { :attribute }
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
          expect(params).to be_nil
        end
        
        it "should swap attr and ability if backwards" do
          allow(FS3Skills).to receive(:get_ability_type).with("Y") { :attribute }
          params = FS3Skills.parse_roll_params("Y+X")
          check_params(params, "X", 0, "Y")
        end

        it "should handle bad string with a non-digit modifier" do
          params = FS3Skills.parse_roll_params("A+B+C")
          expect(params).to be_nil
        end
        
        it "should handle bad string with too many params" do
          params = FS3Skills.parse_roll_params("A+B+2+D")
          expect(params).to be_nil
        end
      end
      
      describe :dice_to_roll_for_ability do
        before do
          @char = double
          allow(@char).to receive(:name) { "Nemo" }

          allow(FS3Skills).to receive(:get_ability_type).with("Firearms") { :action }
          allow(FS3Skills).to receive(:get_ability_type).with("Brawn") { :attribute }
          allow(FS3Skills).to receive(:get_ability_type).with("Reflexes") { :attribute }
          allow(FS3Skills).to receive(:get_ability_type).with("English") { :language }
          allow(FS3Skills).to receive(:get_ability_type).with("Basketweaving") { :background }
          allow(FS3Skills).to receive(:get_ability_type).with("Untrained") { :background }
          allow(FS3Skills).to receive(:get_ability_type).with(nil) { :background }
          
          allow(FS3Skills).to receive(:ability_rating).with(@char, "Untrained") { 0 }
          allow(FS3Skills).to receive(:ability_rating).with(@char, "Firearms") { 1 }
          allow(FS3Skills).to receive(:ability_rating).with(@char, "Basketweaving") { 2 }
          allow(FS3Skills).to receive(:ability_rating).with(@char, "English") { 3 }
          allow(FS3Skills).to receive(:ability_rating).with(@char, "Brawn") { 4 }
          allow(FS3Skills).to receive(:ability_rating).with(@char, "Reflexes") { 2 }
          
          allow(FS3Skills).to receive(:get_linked_attr).with("Untrained") { "Brawn" }
          allow(FS3Skills).to receive(:get_linked_attr).with("Firearms") { "Reflexes" }
          allow(FS3Skills).to receive(:get_linked_attr).with("Brawn") { nil }
          allow(FS3Skills).to receive(:get_linked_attr).with("Basketweaving") { "Reflexes" }
          allow(FS3Skills).to receive(:get_linked_attr).with("English") { "Reflexes" }
        end
      
        it "should roll ability alone" do
          roll_params = RollParams.new("Firearms")
          # Rolls Firearms + Reflexes 
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 3
        end
      
        it "should roll ability + a different ruling attr" do
          roll_params = RollParams.new("Firearms", 0, "Brawn")
          # Rolls Firearms + Brawn
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 5
        end
        
        it "should roll attr + ability" do
          roll_params = RollParams.new("Brawn", 0, "Firearms")
          # Rolls Brawn + Firearms
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 5
        end

        it "should roll attr + attr" do
          roll_params = RollParams.new("Brawn", 0, "Reflexes")
          # Rolls Brawn + Reflexes
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 6
        end
        
        it "should roll ability + ability" do
          roll_params = RollParams.new("Firearms", 0, "Firearms")
          # Rolls Firearms + Firearms
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 2
        end
        
        it "should roll twice a background skill" do 
          roll_params = RollParams.new("Basketweaving")
          # Rolls Basketweaving*2 + Reflexes
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 6
        end
        
        it "should roll twice a language skill" do 
          roll_params = RollParams.new("English")
          # Rolls English*2 + Reflexes
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 8
        end
        
        it "should roll ability + modifier" do
          roll_params = RollParams.new("Firearms", 1)
          # Rolls Firearms + Reflexes + 1
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 4
        end
      
        it "should roll ability - modifier" do
          roll_params = RollParams.new("Firearms", -1)
          # Rolls Firearms + Reflexes - 1 
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 2
        end
      
        it "should roll ability + ruling attr + modifier" do
          roll_params = RollParams.new("Firearms", 3, "Brawn")
          # Rolls Firearms + Brawn + 3 
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 8
        end
        
        it "should roll everyman for an attribute" do
          roll_params = RollParams.new("Brawn")
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 5
        end
        
        it "should roll everyman for nonexistant bg skill" do
          roll_params = RollParams.new("Untrained")
          # Rolls everyman (1) + Brawn
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 5
        end
        
        it "should roll zero for nonexistant lang skill" do
          allow(FS3Skills).to receive(:ability_rating).with(@char, "English") { 0 }
          roll_params = RollParams.new("English")
          # Rolls 0 + Reflexes
          expect(FS3Skills.dice_to_roll_for_ability(@char, roll_params)).to eq 2
        end
        
      end
      
      def check_params(params, ability, modifier, linked_attr)
        expect(params.ability).to eq ability
        expect(params.modifier).to eq modifier
        expect(params.linked_attr).to eq linked_attr
      end
      
      
    end
  end
end
