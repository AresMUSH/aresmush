module AresMUSH
  module Weather
    describe Weather do
          
      before do
        allow(Global).to receive(:read_config).with("weather", "climate_for_area") { { "north" => "Cold", "north pole" => "Polar" }}
        allow(Global).to receive(:read_config).with("weather", "default_climate") { "Tropical" }
        stub_translate_for_testing
      end
            
      describe :climate_for_area do
        it "should get the climate for the area when there's an exact match" do
          climate = Weather.climate_for_area("north")
          expect(climate).to eq "Cold"
        end
        
        it "should get the climate for the parent when there's a parent" do
          area = double
          parent_area = double
          allow(parent_area).to receive(:name) { "north pole" }
          allow(area).to receive(:parent) { parent_area }
          allow(Area).to receive(:find_one_by_name).with("greenland") { area }
          climate = Weather.climate_for_area("greenland")
          expect(climate).to eq "Polar"
        end
        
        it "should get the default weather if no parent" do
          area = double
          allow(area).to receive(:parent) { nil }
          allow(Area).to receive(:find_one_by_name).with("greenland") { area }
          climate = Weather.climate_for_area("greenland")
          expect(climate).to eq "Tropical"
        end
      end
    end
  end
end
