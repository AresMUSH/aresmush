module AresMUSH
  module FS3Combat
    describe FS3Combat do
      before do
        stub_translate_for_testing
      end
      
      describe :find_or_create_vehicle do
        before do
          @instance = double
        end
      
        it "should return a vehicle that already exists" do
          v = double
          allow(@instance).to receive(:find_vehicle_by_name).with("abc") { v }
          expect(FS3Combat.find_or_create_vehicle(@instance, "abc")).to eq v
        end
  
        it "should return nil for invalid vehicle type" do
          allow(Global).to receive(:read_config).with("fs3combat", "vehicles") { { "Viper" => {} } }
          allow(@instance).to receive(:find_vehicle_by_name).with("abc") { nil }
          expect(FS3Combat.find_or_create_vehicle(@instance, "abc")).to eq nil
        end
  
        it "should add a new vehicle" do
          allow(Global).to receive(:read_config).with("fs3combat", "vehicles") { { "Viper" => {} } }
          allow(@instance).to receive(:find_vehicle_by_name).with("Viper") { nil }
          v = double
          allow(Vehicle).to receive(:create) do |args|
            expect(args[:combat]).to eq @instance
            expect(args[:vehicle_type]).to eq "Viper"
            v
          end
          expect(FS3Combat.find_or_create_vehicle(@instance, "Viper")).to eq v
        end
        
        it "should find a vehicle with a case-insensitive name" do
          allow(Global).to receive(:read_config).with("fs3combat", "vehicles") { { "AA Battery" => {} } }
          allow(@instance).to receive(:find_vehicle_by_name).with("aa battery") { nil }
          v = double
          allow(Vehicle).to receive(:create) { v }
          expect(FS3Combat.find_or_create_vehicle(@instance, "aa battery")).to eq v
        end
      end
      
      describe :join_vehicle do
        before do
          @vehicle = double
          @combat = double
          @combatant = double
          
          allow(@vehicle).to receive(:name) { "Viper-1" }
          allow(@combatant).to receive(:name) { "Bob" }
          allow(@combatant).to receive(:update)
          allow(@vehicle).to receive(:pilot) { nil }
          allow(@vehicle).to receive(:vehicle_type) { "Viper" }
          allow(FS3Combat).to receive(:emit_to_combat)
          allow(@vehicle).to receive(:update)

          allow(FS3Combat).to receive(:set_weapon)
          allow(FS3Combat).to receive(:vehicle_stat) { [] }
        end
        
        describe "pilot" do
          it "should move the existing pilot to the passenger list if someone else takes over" do
            old_pilot = double
            allow(@vehicle).to receive(:pilot) { old_pilot }
            
            expect(old_pilot).to receive(:update).with(piloting: nil)
            expect(old_pilot).to receive(:update).with(riding_in: @vehicle)
            expect(@vehicle).to receive(:update).with(pilot: @combatant)
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Pilot")
          end
          
          it "should not move pilot if they're the same as the old pilot" do
            allow(@vehicle).to receive(:pilot) { @combatant }
            expect(@vehicle).to receive(:update).with(pilot: @combatant)
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Pilot")
          end
          
          it "should update the pilot's vehicle stat" do
            expect(@combatant).to receive(:update).with(piloting: @vehicle)
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Pilot")
          end
          
          it "should set up default vehicle weapon" do
            expect(FS3Combat).to receive(:vehicle_stat).with("Viper", "weapons") { ["KEW", "Missile"]}
            expect(FS3Combat).to receive(:set_weapon).with(nil, @combatant, "KEW")
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Pilot")
          end
        
          it "should emit to combat" do
            expect(FS3Combat).to receive(:emit_to_combat).with(@combat, "fs3combat.new_pilot")
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Pilot")
          end
        end
        
        describe "passenger" do
          it "should update the pilot's vehicle stat" do
            expect(@combatant).to receive(:update).with(riding_in: @vehicle)
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Passenger")
          end
          
          it "should emit to combat" do
            expect(FS3Combat).to receive(:emit_to_combat).with(@combat, "fs3combat.new_passenger")
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Passenger")
          end
        end
      end
      
      describe :leave_vehicle do
        before do
          @vehicle = double
          @combat = double
          @combatant = double
        
          allow(@vehicle).to receive(:name) { "Viper-1" }
          allow(@combatant).to receive(:name) { "Bob" }
          allow(FS3Combat).to receive(:emit_to_combat)
          allow(@combatant).to receive(:update)
          allow(@vehicle).to receive(:update)
          
          allow(FS3Combat).to receive(:set_default_gear) {}
          allow(Global).to receive(:read_config).with("fs3combat", "default_type") { "soldier" }
        end
      
        it "should remove a pilot" do
          allow(@combatant).to receive(:piloting) { @vehicle }
          expect(@combatant).to receive(:update).with(piloting: nil)
          expect(@vehicle).to receive(:update).with(pilot: nil)
          FS3Combat.leave_vehicle(@combat, @combatant)
        end
        
        it "should emit to combat" do
          allow(@combatant).to receive(:piloting) { @vehicle }
          expect(FS3Combat).to receive(:emit_to_combat).with(@combat, "fs3combat.disembarks_vehicle")
          FS3Combat.leave_vehicle(@combat, @combatant)
        end
      
        it "should remove a passenger" do
          allow(@combatant).to receive(:piloting) { nil }
          allow(@combatant).to receive(:riding_in) { @vehicle }
          expect(@combatant).to receive(:update).with(riding_in: nil)
          FS3Combat.leave_vehicle(@combat, @combatant)
        end
        
        it "should reset gear" do
          allow(@combatant).to receive(:piloting) { @vehicle }
          expect(FS3Combat).to receive(:set_default_gear).with(nil, @combatant, "soldier")
          FS3Combat.leave_vehicle(@combat, @combatant)
        end
        
      end
      
    end
  end
end
