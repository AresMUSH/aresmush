module AresMUSH
  module FS3Combat
    describe FS3Combat do
      describe :join_combat do
        before do
          @combat = double
          @enactor = double
          @client = double
          
          @combat.stub(:emit)
          
          FS3Combat.stub(:is_in_combat?) { false }
          ClassTargetFinder.stub(:find) { FindResult.new(nil, "error") }
          FS3Combat.stub(:combatant_type_stat) { nil }
          FS3Combat.stub(:set_default_gear)
          SpecHelpers.stub_translate_for_testing
        end
  
        it "should fail if already in combat" do
          FS3Combat.should_receive(:is_in_combat?).with("Bob") { true }
          @client.should_receive(:emit_failure).with("fs3combat.already_in_combat")
          FS3Combat.join_combat(@combat, "Bob", "soldier", @enactor, @client)
        end
        
        it "should create a NPC if char not found" do
          ClassTargetFinder.should_receive(:find).with("Bob", Character, @enactor) { FindResult.new(nil, "error") }
          npc = double
          Npc.should_receive(:create).with(name: "Bob") { npc }
          Combatant.should_receive(:create) do |params|
            params[:combatant_type].should eq "soldier"
            params[:team].should eq 2
            params[:npc].should eq npc
            params[:combat].should eq @combat
          end
          FS3Combat.join_combat(@combat, "Bob", "soldier", @enactor, @client)
        end
        
        it "should create a combatant for a character if found" do
          char = double
          ClassTargetFinder.should_receive(:find).with("Bob", Character, @enactor) { FindResult.new(char) }
          Combatant.should_receive(:create) do |params|
            params[:combatant_type].should eq "soldier"
            params[:team].should eq 1
            params[:character].should eq char
            params[:combat].should eq @combat
          end
          FS3Combat.join_combat(@combat, "Bob", "soldier", @enactor, @client)
        end
        
        
        it "should create a vehicle if specified" do
          char = double
          combatant = double
          vehicle = double
          ClassTargetFinder.should_receive(:find).with("Bob", Character, @enactor) { FindResult.new(char) }
          Combatant.stub(:create) { combatant }
          FS3Combat.should_receive(:combatant_type_stat).with("viper", "vehicle") { "Viper" }
          FS3Combat.should_receive(:find_or_create_vehicle).with(@combat, "Viper") { vehicle }
          FS3Combat.should_receive(:join_vehicle).with(@combat, combatant, vehicle, "Pilot")
          FS3Combat.join_combat(@combat, "Bob", "viper", @enactor, @client)
        end
        
        
        it "should emit join message to combat" do
          combatant = double
          Npc.stub(:create)
          Combatant.stub(:create) { combatant }
          @combat.should_receive(:emit).with("fs3combat.has_joined")
          FS3Combat.join_combat(@combat, "Bob", "soldier", @enactor, @client)
        end
        
        it "should set default gear" do
          combatant = double
          Npc.stub(:create)
          Combatant.stub(:create) { combatant }
          FS3Combat.should_receive(:set_default_gear).with(@enactor, combatant, "soldier")
          FS3Combat.join_combat(@combat, "Bob", "soldier", @enactor, @client)
        end
      end
    end
  end
end