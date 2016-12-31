module AresMUSH
  module FS3Skills
    describe OpposedRollCmd do
      describe :crack do
        it "should fail if the string is invalid" do
          handler = OpposedRollCmd.new(nil, Command.new("roll A vs B"), nil)
          handler.parse_args
          handler.name1.should be_nil
          handler.name2.should be_nil
          handler.roll_str1.should be_nil
          handler.roll_str2.should be_nil
        end
        
        it "should crack a PC roll vs a NPC number" do
          handler = OpposedRollCmd.new(nil, Command.new("roll A/1 vs 3"), nil)
          handler.parse_args
          handler.name1.should eq "A"
          handler.name2.should be_nil
          handler.roll_str1.should eq "1"
          handler.roll_str2.should eq "3"
        end
        
        it "should crack a PC roll vs another PC" do
          handler = OpposedRollCmd.new(nil, Command.new("roll A/Firearms vs B/Melee"), nil)
          handler.parse_args
          handler.name1.should eq "A"
          handler.name2.should eq "B"
          handler.roll_str1.should eq "Firearms"
          handler.roll_str2.should eq "Melee"
        end
        
        it "should crack skill names with spaces" do
          handler = OpposedRollCmd.new(nil, Command.new("roll A/Basket Weaving+2 vs B/Scuba Diving - 1"), nil)
          handler.parse_args
          handler.name1.should eq "A"
          handler.name2.should eq "B"
          handler.roll_str1.should eq "Basket Weaving+2"
          handler.roll_str2.should eq "Scuba Diving - 1"
        end
        
      end
    end
  end
end