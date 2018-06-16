module AresMUSH
  module FS3Skills
    describe OpposedRollCmd do
      describe :crack do
        it "should fail if the string is invalid" do
          handler = OpposedRollCmd.new(nil, Command.new("roll A vs B"), nil)
          handler.parse_args
          expect(handler.name1).to be_nil
          expect(handler.name2).to be_nil
          expect(handler.roll_str1).to be_nil
          expect(handler.roll_str2).to be_nil
        end
        
        it "should crack a PC roll vs a NPC number" do
          handler = OpposedRollCmd.new(nil, Command.new("roll A/1 vs 3"), nil)
          handler.parse_args
          expect(handler.name1).to eq "A"
          expect(handler.name2).to be_nil
          expect(handler.roll_str1).to eq "1"
          expect(handler.roll_str2).to eq "3"
        end
        
        it "should crack a PC roll vs another PC" do
          handler = OpposedRollCmd.new(nil, Command.new("roll A/Firearms vs B/Melee"), nil)
          handler.parse_args
          expect(handler.name1).to eq "A"
          expect(handler.name2).to eq "B"
          expect(handler.roll_str1).to eq "Firearms"
          expect(handler.roll_str2).to eq "Melee"
        end
        
        it "should crack skill names with spaces" do
          handler = OpposedRollCmd.new(nil, Command.new("roll A/Basket Weaving+2 vs B/Scuba Diving - 1"), nil)
          handler.parse_args
          expect(handler.name1).to eq "A"
          expect(handler.name2).to eq "B"
          expect(handler.roll_str1).to eq "Basket Weaving+2"
          expect(handler.roll_str2).to eq "Scuba Diving - 1"
        end
        
      end
    end
  end
end
