module AresMUSH
  module FS3Combat
    describe FS3Combat do
      include MockClient
      
      before do
        Global.stub(:config) { { "fs3combat" => { "toughness_attribute" => "Body" } } }
      end
        
      describe :heal_wounds do
        before do
          @char = double
          @char.stub(:name) { "Bob" }
          @damage1 = double
          @damage2 = double
          @wounds =  [@damage1, @damage2]
        end
        
        it "should apply healing points based on half successes" do
          FS3Skills.stub(:one_shot_roll) { { :successes => 0 }}
          @damage1.should_receive(:heal).with(2, true)
          @damage2.should_receive(:heal).with(2, true)
          FS3Combat.heal_wounds(@char, @wounds, 3)
        end
        
        it "should add a body roll to the healing points" do
          FS3Skills.should_receive(:one_shot_roll).with(nil, @char, { :ability => "Body", :ruling_attr => "Body" } ) { { :successes => 2 }}
          @damage1.should_receive(:heal).with(3, true)
          @damage2.should_receive(:heal).with(3, true)        
          FS3Combat.heal_wounds(@char, @wounds, 3)
        end
        
        it "should not mark wounds as treated if no healing points" do
          FS3Skills.stub(:one_shot_roll) { { :successes => 1 }}
          @damage1.should_receive(:heal).with(1, false)
          @damage2.should_receive(:heal).with(1, false)        
          FS3Combat.heal_wounds(@char, @wounds, 0)
        end
      end
    end
  end
end