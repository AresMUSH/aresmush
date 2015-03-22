module AresMUSH
  module FS3Combat
    describe CombatInstance do
      include MockClient
      
      before do
        @instance = CombatInstance.new(nil)
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :join do
        before do
          @bob_mock = build_mock_client
          @bob_mock[:client].stub(:name) { "Bob" }
          AresMUSH::Locale.stub(:translate).with("fs3combat.combat_emit", { :message => "fs3combat.has_joined" }) { "join emit" }        
        end
        
        it "should create a new combatant" do
          @bob_mock[:client].stub(:emit)
          @instance.join("Bob", "soldier", @bob_mock[:char])
          @instance.combatants[0].name.should eq "Bob"
          @instance.combatants[0].combatant_type.should eq "soldier"
        end
        
        it "should emit to combat" do
          @bob_mock[:client].should_receive(:emit).with("join emit")
          @instance.join("Bob", "soldier", @bob_mock[:char])
        end
      end
      
      describe :has_combatant? do
        it "should return true if there is someone with the name" do
          @instance.join("Bob", "soldier")
          @instance.has_combatant?("Bob").should be_true
          @instance.has_combatant?("bOb").should be_true
        end
        
        it "should return false if there is not someone with the name" do
          @instance.join("Bob", "soldier")
          @instance.has_combatant?("Harvey").should be_false
        end
      end
      
      describe :find_combatant do
        it "should find combatant is someone with the name" do
          @instance.join("Bob", "soldier")
          bob = @instance.combatants[0]
          @instance.find_combatant("Bob").should eq bob
        end
        
        it "should return nil if there is not someone with the name" do
          @instance.join("Bob", "soldier")
          @instance.find_combatant("Harvey").should be_nil
        end
      end
      
      describe :emit do
        before do
          @bob_mock = build_mock_client
          @harvey_mock = build_mock_client
          
          @bob_mock[:client].stub(:name) { "Bob" }
          @harvey_mock[:client].stub(:name) { "Harvey" }
          
          @instance.combatants << Combatant.new("Bob", "soldier", @bob_mock[:char])
          @instance.combatants << Combatant.new("Harvey", "organizer", @harvey_mock[:char])
          
          AresMUSH::Locale.stub(:translate).with("fs3combat.combat_emit", { :message => "Test" }) { "test emit" }        
          AresMUSH::Locale.stub(:translate).with("fs3combat.combat_emit", { :message => "Bob test" }) { "bob not highlighted" }        
          AresMUSH::Locale.stub(:translate).with("fs3combat.combat_emit", { :message => "%xh%xyBob%xn test" }) { "bob highlighted" }        
          AresMUSH::Locale.stub(:translate).with("fs3combat.combat_emit", { :message => "Test (Master)" }) { "test with master" }        
        end
        
        it "should emit to everyone" do
          @bob_mock[:client].should_receive(:emit).with("test emit")
          @harvey_mock[:client].should_receive(:emit).with("test emit")
          @instance.emit("Test")
        end
        
        it "should highlight the char's name" do
          @bob_mock[:client].should_receive(:emit).with("bob highlighted")
          @harvey_mock[:client].should_receive(:emit).with("bob not highlighted")
          @instance.emit("Bob test")
        end
        
        it "should tack on the npcmaster's name if specified" do
          @bob_mock[:client].should_receive(:emit).with("test with master")
          @harvey_mock[:client].should_receive(:emit).with("test with master")
          @instance.emit("Test", "Master")
        end
      end
      
      describe :emit_to_organizer do
        before do
          @bob_mock = build_mock_client
          @harvey_mock = build_mock_client
                    
          @instance.combatants << Combatant.new("Bob", "soldier", @bob_mock[:char])
          @instance.organizer = @harvey_mock[:char]

          AresMUSH::Locale.stub(:translate).with("fs3combat.organizer_emit", { :message => "Test" }) { "test emit" }        
          AresMUSH::Locale.stub(:translate).with("fs3combat.organizer_emit", { :message => "Test (Master)" }) { "test with master" }        
        end
        
        it "should emit to the organizer only" do
          @harvey_mock[:client].should_receive(:emit).with("test emit")
          @bob_mock[:client].should_not_receive(:emit)
          @instance.emit_to_organizer("Test")
        end
        
        it "should tack on the npcmaster's name if specified" do
          @harvey_mock[:client].should_receive(:emit).with("test with master")
          @instance.emit_to_organizer("Test", "Master")
        end
      end
    end
  end
end