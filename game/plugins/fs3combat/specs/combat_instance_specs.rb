module AresMUSH
  module FS3Combat
    describe Combat do
      
      before do
        @instance = Combat.new
        @instance.stub(:save) { }
        
        @bob = double
        @bob.stub(:name_upcase) { "BOB" }
        
        @harvey = double
        @harvey.stub(:name_upcase) { "HARVEY" }
        
        @instance.stub(:combatants) { [ @bob, @harvey ] }
        
        SpecHelpers.stub_translate_for_testing
      end
      
            
      describe :has_combatant? do
        it "should return true if there is someone with the name" do
          @instance.has_combatant?("Bob").should be_true
          @instance.has_combatant?("bOb").should be_true
        end
        
        it "should return false if there is not someone with the name" do
          @instance.has_combatant?("Jane").should be_false
        end
      end
      
      describe :find_combatant do
        it "should find combatant is someone with the name" do
          @instance.find_combatant("Bob").should eq @bob
        end
        
        it "should return nil if there is not someone with the name" do
          @instance.find_combatant("Jane").should be_nil
        end
      end
      
      describe :emit do
        
        it "should emit to everyone" do
          @bob.should_receive(:emit).with("Test")
          @harvey.should_receive(:emit).with("Test")
          @instance.emit("Test")
        end
        
        it "should tack on the npcmaster's name if specified" do
          @bob.should_receive(:emit).with("Test (Master)")
          @harvey.should_receive(:emit).with("Test (Master)")
          @instance.emit("Test", " (Master)")
        end
      end
      
      describe :emit_to_organizer do
        before do
          @harvey_client = double
          @instance.stub(:organizer) { @harvey }
          @harvey.stub(:client) { @harvey_client }
          AresMUSH::Locale.stub(:translate).with("fs3combat.organizer_emit", { :message => "Test" }) { "test emit" }        
          AresMUSH::Locale.stub(:translate).with("fs3combat.organizer_emit", { :message => "Test (Master)" }) { "test with master" }        
        end
        
        it "should emit to the organizer only" do
          @harvey_client.should_receive(:emit).with("test emit")
          @bob.should_not_receive(:emit)
          @instance.emit_to_organizer("Test")
        end
        
        it "should tack on the npcmaster's name if specified" do
          @harvey_client.should_receive(:emit).with("test with master")
          @instance.emit_to_organizer("Test", "Master")
        end
      end
      
    end
  end
end