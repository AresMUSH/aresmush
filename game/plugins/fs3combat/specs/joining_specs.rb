module AresMUSH
  module FS3Combat
    describe FS3Combat do
      before do
        @instance = Combat.new
        @instance.stub(:save) { }
      end
      describe :join do
        before do
          @combatants = []
          Combatant.stub(:create).with(:name => "Bob", :combatant_type => "soldier", :character => @bob, :team => 1) { @bob }
          @instance.stub(:combatants) { @combatants }
        end
  
        it "should create a new combatant" do
          @bob.stub(:emit)
          FS3Combat.join_combat(@instance, "Bob", "soldier", @bob)
          @instance.combatants[0].should eq @bob
        end
  
        it "should emit to combat" do
          @bob.should_receive(:emit).with("fs3combat.has_joined")
          FS3Combat.join_combat(@instance, "Bob", "soldier", @bob)
        end
      end

      describe :leave do
        before do
          @bob.stub(:emit)
          @harvey.stub(:emit)
          @harvey.stub(:clear_mock_damage)
          @harvey.stub(:delete)
        end
  
        it "should delete a combatant" do
          @harvey.should_receive(:delete)
          FS3Combat.leave_combat(@instance, "Harvey")
        end
  
        it "should emit to combat" do
          @bob.should_receive(:emit).with("fs3combat.has_left")
          @harvey.should_receive(:emit).with("fs3combat.has_left")
          FS3Combat.leave_combat(@instance, "Harvey")
        end
      end
    end
  end
end