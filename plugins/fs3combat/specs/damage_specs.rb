module AresMUSH
  module FS3Combat
    describe FS3Combat do
      
      describe :wound_mod do
        before do
          allow(Global).to receive(:read_config).with("fs3combat", "damage_mods") { { "HEAL" => 0, "GRAZE" => 1, "IMPAIR" => 3  } }          
        end
        
        it "should return the correct wound modifier" do
          wound = Damage.new(:current_severity => "IMPAIR")
          expect(wound.wound_mod).to eq 3
        end
        
        it "should return 0 for a healed wound" do
          wound = Damage.new(:current_severity => "HEAL")
          expect(wound.wound_mod).to eq 0
        end

        it "should return one third for a treated wound" do
          wound = Damage.new(:current_severity => "IMPAIR", :healed => true)
          expect(wound.wound_mod).to eq 1
        end        
      end
      
      describe :is_treatable? do
        it "should be treatable if it's been less than 24 hours" do
          allow(Time).to receive(:now) { Time.new(2014, 01, 02, 3, 0, 0) }
          damage = Damage.new(created_at: Time.new(2014, 01, 01, 4, 1, 0))
          expect(damage.is_treatable?).to be true
        end
        
        it "should not be treatable if it's been more than 24 hours" do
          allow(Time).to receive(:now) { Time.new(2014, 01, 02, 8, 0, 0) }
          damage = Damage.new(created_at: Time.new(2014, 01, 01, 3, 59, 0))
          expect(damage.is_treatable?).to be false
        end
        
        it "should not be treatable if it's already been treated" do
          allow(Time).to receive(:now) { Time.new(2014, 01, 01, 8, 0, 0) }
          damage = Damage.new(created_at: Time.new(2014, 01, 01, 4, 1, 0), :healed => true)
          expect(damage.is_treatable?).to be false
        end
        
      end
    end
  end
end
