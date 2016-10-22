module AresMUSH
  module FS3Combat
    describe FS3Combat do
      before do
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :find_or_create_vehicle do
        before do
          @instance = double
        end
      
        it "should return a vehicle that already exists" do
          v = double
          @instance.stub(:find_vehicle_by_name).with("abc") { v }
          FS3Combat.find_or_create_vehicle(@instance, "abc").should eq v
        end
  
        it "should return nil for invalid vehicle type" do
          Global.stub(:read_config).with("fs3combat", "vehicles") { { "Viper" => {} } }
          @instance.stub(:find_vehicle_by_name).with("abc") { nil }
          FS3Combat.find_or_create_vehicle(@instance, "abc").should eq nil
        end
  
        it "should add a new vehicle" do
          # This random seed guarantees the Viper # will always be UT7045
          Kernel.srand 22
          Global.stub(:read_config).with("fs3combat", "vehicles") { { "Viper" => {} } }
          @instance.stub(:find_vehicle_by_name).with("Viper") { nil }
          v = double
          Vehicle.stub(:create) do |args|
            args[:combat].should eq @instance
            args[:name].should eq "Viper-UT7045"
            args[:vehicle_type].should eq "Viper"
            v
          end
          FS3Combat.find_or_create_vehicle(@instance, "Viper").should eq v
        end
      end
      
      describe :join_vehicle do
        before do
          @vehicle = double
          @combat = double
          @combatant = double
          @passenger_list = double
          
          @vehicle.stub(:name) { "Viper-1" }
          @combatant.stub(:name) { "Bob" }
          @combatant.stub(:update)
          @vehicle.stub(:pilot) { nil }
          @vehicle.stub(:vehicle_type) { "Viper" }
          @combat.stub(:emit)
          @vehicle.stub(:update)
          @vehicle.stub(:passengers) { @passenger_list }

          FS3Combat.stub(:set_weapon)
          FS3Combat.stub(:vehicle_stat) { [] }
        end
        
        describe "pilot" do
          it "should move the existing pilot to the passenger list if someone else takes over" do
            old_pilot = double
            @vehicle.stub(:pilot) { old_pilot }
            
            old_pilot.should_receive(:update).with(piloting: nil)
            old_pilot.should_receive(:update).with(riding_in: @vehicle)
            @vehicle.should_receive(:update).with(pilot: @combatant)
            @passenger_list.should_receive(:add).with(old_pilot)
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Pilot")
          end
          
          it "should not move pilot if they're the same as the old pilot" do
            @vehicle.stub(:pilot) { @combatant }
            @vehicle.should_receive(:update).with(pilot: @combatant)
            @passenger_list.should_not_receive(:add)
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Pilot")
          end
          
          it "should update the pilot's vehicle stat" do
            @combatant.should_receive(:update).with(piloting: @vehicle)
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Pilot")
          end
          
          it "should set up default vehicle weapon" do
            FS3Combat.should_receive(:vehicle_stat).with("Viper", "weapons") { ["KEW", "Missile"]}
            FS3Combat.should_receive(:set_weapon).with(nil, @combatant, "KEW")
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Pilot")
          end
        
          it "should emit to combat" do
            @combat.should_receive(:emit).with("fs3combat.new_pilot")
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Pilot")
          end
        end
        
        describe "passenger" do
          it "should add passenger to the list" do
            @passenger_list.should_receive(:add).with(@combatant)
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Passenger")
          end
          
          it "should update the pilot's vehicle stat" do
            @passenger_list.stub(:add)
            @combatant.should_receive(:update).with(riding_in: @vehicle)
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Passenger")
          end
          
          it "should emit to combat" do
            @passenger_list.stub(:add)
            @combat.should_receive(:emit).with("fs3combat.new_passenger")
            FS3Combat.join_vehicle(@combat, @combatant, @vehicle, "Passenger")
          end
        end
      end
      
      describe :leave_vehicle do
        before do
          @vehicle = double
          @combat = double
          @combatant = double
          @passenger_list = double
        
          @vehicle.stub(:name) { "Viper-1" }
          @combatant.stub(:name) { "Bob" }
          @combat.stub(:emit)
          @combatant.stub(:update)
          @vehicle.stub(:update)
          @vehicle.stub(:passengers) { @passenger_list }
        end
      
        it "should remove a pilot" do
          @combatant.stub(:piloting) { @vehicle }
          @combatant.should_receive(:update).with(piloting: nil)
          @vehicle.should_receive(:update).with(pilot: nil)
          FS3Combat.leave_vehicle(@combat, @combatant)
        end
        
        it "should emit to combat" do
          @combatant.stub(:piloting) { @vehicle }
          @combat.should_receive(:emit).with("fs3combat.disembarks_vehicle")
          FS3Combat.leave_vehicle(@combat, @combatant)
        end
      
        it "should remove a passenger" do
          @combatant.stub(:piloting) { nil }
          @combatant.stub(:riding_in) { @vehicle }
          @combatant.should_receive(:update).with(riding_in: nil)
          @passenger_list.should_receive(:delete).with(@combatant)
          FS3Combat.leave_vehicle(@combat, @combatant)
        end
      end
      
    end
  end
end