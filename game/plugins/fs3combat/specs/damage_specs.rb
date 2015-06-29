module AresMUSH
  module FS3Combat
    describe FS3Combat do
      include MockClient
      
      describe :heal do
        before do
          Global.stub(:read_config).with("fs3combat", "healing_points", "L") { 2 }
          Global.stub(:read_config).with("fs3combat", "healing_points", "H") { 0 }
        end
        
        it "should not touch a healed wound" do
          damage = Damage.new(:healing_points => 0)
          damage.should_not_receive(:save)
          damage.heal(1)
          damage.healing_points.should eq 0
        end
        
        it "should heal at least one point" do
          damage = Damage.new(:healing_points => 3)
          damage.should_receive(:save) {}
          damage.heal(0)
          damage.healing_points.should eq 2
        end
        
        it "should lower severity and reset points when a wound gets enough healing points" do
          damage = Damage.new(:healing_points => 3, :current_severity => "M")
          damage.should_receive(:save) {}
          damage.heal(4)
          damage.healing_points.should eq 2
          damage.current_severity.should eq "L"
        end
        
        it "should set healing points to 0 for a completely healed wound" do
          damage = Damage.new(:healing_points => 3, :current_severity => "L")
          damage.should_receive(:save) {}
          damage.heal(4)
          damage.healing_points.should eq 0
          damage.current_severity.should eq "H"
        end
      end
    end
  end
end