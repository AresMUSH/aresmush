module AresMUSH
  module FS3Combat
    describe FS3Combat do
      describe :join_combat do
        before do
          @combat = double
          @enactor = double
          @client = double
          @char = double
          
          allow(@char).to receive(:name) { "Bob" }
          allow(FS3Combat).to receive(:emit_to_combat) {}
          allow(FS3Combat).to receive(:is_in_combat?) { false }
          allow(ClassTargetFinder).to receive(:find) { FindResult.new(nil, "error") }
          allow(FS3Combat).to receive(:combatant_type_stat) { nil }
          allow(FS3Combat).to receive(:set_default_gear)
          allow(FS3Combat).to receive(:handle_combat_join_achievement) {}
          stub_translate_for_testing
        end
  
        it "should fail if already in combat" do
          expect(ClassTargetFinder).to receive(:find).with("Bo", Character, @enactor) { FindResult.new(@char, nil) }

          expect(FS3Combat).to receive(:is_in_combat?).with("Bob") { true }
          expect(@client).to receive(:emit_failure).with("fs3combat.already_in_combat")
          FS3Combat.join_combat(@combat, "Bo", "soldier", @enactor, @client)
        end
        
        it "should find a partial person match already in combat" do
          expect(ClassTargetFinder).to receive(:find).with("Bo", Character, @enactor) { FindResult.new(@char, nil) }
          
          expect(FS3Combat).to receive(:is_in_combat?).with("Bob") { true }
          expect(@client).to receive(:emit_failure).with("fs3combat.already_in_combat")
          FS3Combat.join_combat(@combat, "Bo", "soldier", @enactor, @client)
        end
        
        it "should create a NPC if char not found" do
          expect(ClassTargetFinder).to receive(:find).with("Bob", Character, @enactor) { FindResult.new(nil, "error") }
          npc = double
          expect(Npc).to receive(:create).with(name: "Bob", combat: @combat, level: "Boss") { npc }
          expect(FS3Combat).to receive(:default_npc_type) { "Boss" }
          expect(Combatant).to receive(:create) do |params|
            expect(params[:combatant_type]).to eq "soldier"
            expect(params[:team]).to eq 9
            expect(params[:npc]).to eq npc
            expect(params[:combat]).to eq @combat
          end
          FS3Combat.join_combat(@combat, "Bob", "soldier", @enactor, @client)
        end
        
        it "should create a combatant for a character if found" do
          expect(ClassTargetFinder).to receive(:find).with("Bob", Character, @enactor) { FindResult.new(@char) }
          expect(Combatant).to receive(:create) do |params|
            expect(params[:combatant_type]).to eq "soldier"
            expect(params[:team]).to eq 1
            expect(params[:character]).to eq @char
            expect(params[:combat]).to eq @combat
          end
          FS3Combat.join_combat(@combat, "Bob", "soldier", @enactor, @client)
        end
        
        
        it "should create a vehicle if specified" do
          combatant = double
          vehicle = double
          expect(ClassTargetFinder).to receive(:find).with("Bob", Character, @enactor) { FindResult.new(@char) }
          allow(Combatant).to receive(:create) { combatant }
          expect(FS3Combat).to receive(:combatant_type_stat).with("viper", "vehicle") { "Viper" }
          expect(FS3Combat).to receive(:find_or_create_vehicle).with(@combat, "Viper") { vehicle }
          expect(FS3Combat).to receive(:join_vehicle).with(@combat, combatant, vehicle, "Pilot")
          FS3Combat.join_combat(@combat, "Bob", "viper", @enactor, @client)
        end
        
        
        it "should emit join message to combat" do
          combatant = double
          allow(Npc).to receive(:create)
          allow(Combatant).to receive(:create) { combatant }
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat, "fs3combat.has_joined")
          FS3Combat.join_combat(@combat, "Bob", "soldier", @enactor, @client)
        end
        
        it "should set default gear" do
          combatant = double
          allow(Npc).to receive(:create)
          allow(Combatant).to receive(:create) { combatant }
          expect(FS3Combat).to receive(:set_default_gear).with(@enactor, combatant, "soldier")
          FS3Combat.join_combat(@combat, "Bob", "soldier", @enactor, @client)
        end
      end
    end
  end
end
