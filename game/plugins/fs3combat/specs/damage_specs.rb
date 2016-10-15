module AresMUSH
  module FS3Combat
    describe FS3Combat do
      
      describe :wound_mod do
        before do
          Global.stub(:read_config).with("fs3combat", "damage_mods") { { "H" => 0, "L" => 1, "M" => 2  } }          
        end
        
        it "should return the correct wound modifier" do
          wound = Damage.new(:current_severity => "M")
          wound.wound_mod.should eq 2
        end
        
        it "should return 0 for a healed wound" do
          wound = Damage.new(:current_severity => "H")
          wound.wound_mod.should eq 0
        end

        it "should return half for a treated wound" do
          wound = Damage.new(:current_severity => "M", :last_treated => DateTime.now)
          wound.wound_mod.should eq 1
        end        
      end
    end
  end
end