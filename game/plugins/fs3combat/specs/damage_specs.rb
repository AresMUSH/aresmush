module AresMUSH
  module FS3Combat
    describe FS3Combat do
      
      describe :wound_mod do
        before do
          Global.stub(:read_config).with("fs3combat", "damage_mods") { { "HEAL" => 0, "GRAZE" => 1, "IMPAIR" => 3  } }          
        end
        
        it "should return the correct wound modifier" do
          wound = Damage.new(:current_severity => "IMPAIR")
          wound.wound_mod.should eq 3
        end
        
        it "should return 0 for a healed wound" do
          wound = Damage.new(:current_severity => "HEAL")
          wound.wound_mod.should eq 0
        end

        it "should return one third for a treated wound" do
          wound = Damage.new(:current_severity => "IMPAIR", :healed => true)
          wound.wound_mod.should eq 1
        end        
      end
      
      describe :is_treatable? do
        it "should be treatable if it's been less than four hours" do
          Time.stub(:now) { Time.new(2014, 01, 01, 8, 0, 0) }
          damage = Damage.new(created_at: Time.new(2014, 01, 01, 4, 1, 0))
          damage.is_treatable?.should be_true
        end
        
        it "should not be treatable if it's been more than four hours" do
          Time.stub(:now) { Time.new(2014, 01, 01, 8, 0, 0) }
          damage = Damage.new(created_at: Time.new(2014, 01, 01, 3, 59, 0))
          damage.is_treatable?.should be_false
        end
        
        it "should not be treatable if it's already been treated" do
          Time.stub(:now) { Time.new(2014, 01, 01, 8, 0, 0) }
          damage = Damage.new(created_at: Time.new(2014, 01, 01, 4, 1, 0), :healed => true)
          damage.is_treatable?.should be_false
        end
        
      end
    end
  end
end