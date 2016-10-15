module AresMUSH
  module FS3Combat
    describe FS3Combat do
      before do
        @instance = Combat.new
        @instance.stub(:save) {}
      end
      
      describe :find_or_create_vehicle do
        it "should return a vehicle that already exists" do
          v = Vehicle.new(name: "ABC")
          @instance.stub(:vehicles) { [v] }
          FS3Combat.find_or_create_vehicle(@instance, "ABC").should eq v
        end
  
        it "should return nil for invalid vehicle type" do
          Global.stub(:read_config).with("fs3combat", "vehicles") { { "Viper" => {} } }
          @instance.stub(:vehicles) { [] }
          FS3Combat.find_or_create_vehicle(@instance, "ABC").should eq nil
        end
  
        it "should add a new vehicle" do
          # This random seed guarantees the Viper # will always be UT7045
          Kernel.srand 22
          Global.stub(:read_config).with("fs3combat", "vehicles") { { "Viper" => {} } }
          @instance.stub(:vehicles) { [] }
          v = double
          Vehicle.stub(:create) do |args|
            args[:combat].should eq @instance
            args[:name].should eq "Viper-UT7045"
            v
          end
          FS3Combat.find_or_create_vehicle(@instance, "Viper").should eq v
        end
      end
    end
  end
end