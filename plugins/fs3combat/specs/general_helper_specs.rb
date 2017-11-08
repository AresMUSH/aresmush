module AresMUSH
  module FS3Combat
    describe FS3Combat do
      include GlobalTestHelper

      describe :find_combat_by_number do
        before do
          @combat1 = double
          @combat2 = double
          @client = double
          Combat.stub(:[]).with(1) { @combat1 }
          Combat.stub(:[]).with(2) { @combat2 }
          Combat.stub(:[]).with(3) { nil }
          SpecHelpers.stub_translate_for_testing
        end
        
        it "should fail if not a number" do
          @client.should_receive(:emit_failure).with("fs3combat.invalid_combat_number")
          FS3Combat.find_combat_by_number(@client, "A").should be_nil
        end
        
        it "should fail if not a valid number" do
          @client.should_receive(:emit_failure).with("fs3combat.invalid_combat_number")
          FS3Combat.find_combat_by_number(@client, 3).should be_nil
        end
        
        it "should succeed if valid number string specified" do
          FS3Combat.find_combat_by_number(@client, "1").should eq @combat1
          FS3Combat.find_combat_by_number(@client, "2").should eq @combat2
        end
        
        it "should succeed if valid number specified" do
          FS3Combat.find_combat_by_number(@client, 1).should eq @combat1
          FS3Combat.find_combat_by_number(@client, 2).should eq @combat2
        end
        
      end
    end
    
    
    describe :emit do
      before do
        @instance = double
        @bob = double
        @harvey = double
        @bob.stub(:name) { "Bob" }
        @harvey.stub(:name) { "Harvey" }
        @harvey.stub(:character) { double }
        @bob.stub(:character) { double }
        @instance.stub(:combatants) { [ @bob, @harvey ] }
        @instance.stub(:log) { }
        @instance.stub(:organizer) { @harvey }
        
        @notifier = double
        Global.stub(:notifier) { @notifier }
        @instance.stub(:organizer) { @harvey }
        
        AresMUSH::Locale.stub(:translate).with("fs3combat.combat_emit", { :message => "Test" }) { "Test" }        
        AresMUSH::Locale.stub(:translate).with("fs3combat.combat_emit", { :message => "Test (Master)" }) { "Test (Master)" }
        AresMUSH::Locale.stub(:translate).with("fs3combat.organizer_emit", { :message => "Test" }) { "org emit" }        
        AresMUSH::Locale.stub(:translate).with("fs3combat.organizer_emit", { :message => "Test (Master)" }) { "org (Master)" }        
      end
      
      context "emit" do
        it "should emit to everyone" do
          @notifier.should_receive(:notify).with(:combat, "Test")
          @notifier.should_receive(:notify).with(:combat, "Test")
          FS3Combat.emit_to_combat(@instance, "Test")
        end
      
        it "should tack on the npcmaster's name if specified" do
          @notifier.should_receive(:notify).with(:combat, "Test (Master)")
          @notifier.should_receive(:notify).with(:combat, "Test (Master)")
          FS3Combat.emit_to_combat(@instance, "Test", " (Master)")
        end    
      end
      
      context "emit to organizer" do
        it "should emit to the organizer" do
          @notifier.should_receive(:notify).with(:combat, "org emit")
          FS3Combat.emit_to_organizer(@instance, "Test")
        end
      
        it "should tack on the npcmaster's name if specified" do
          @notifier.should_receive(:notify).with(:combat, "org (Master)")
          FS3Combat.emit_to_organizer(@instance, "Test", "Master")
        end
      end
      
    end
    
    describe :get_initiative_order do
      it "should return combatants in order of initiative roll" do
        @combat = double
        @combat.stub(:log)
        @combatant1 = double
        @combatant2 = double
        @combatant3 = double
        
        @combatant1.stub(:name) { "A" }
        @combatant2.stub(:name) { "B" }
        @combatant3.stub(:name) { "C" }
        
        @combatant1.stub(:id) { 1 }
        @combatant2.stub(:id) { 2 }
        @combatant3.stub(:id) { 3 }

        @combat.stub(:active_combatants) { [ @combatant1, @combatant2, @combatant3 ]}
        
        Global.stub(:read_config).with("fs3combat", "initiative_skill") { "init" }
        
        FS3Combat.should_receive(:roll_initiative).with(@combatant1, "init") { 3 }
        FS3Combat.should_receive(:roll_initiative).with(@combatant2, "init") { 5 }
        FS3Combat.should_receive(:roll_initiative).with(@combatant3, "init") { 1 }
        
        FS3Combat.get_initiative_order(@combat).should eq [ 2, 1, 3 ]
      end
    end
    
    
  end
end