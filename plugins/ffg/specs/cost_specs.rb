module AresMUSH
  module Ffg
    describe Ffg do 
      
      before do
        stub_translate_for_testing
      end      

      describe :characteristic_xp_cost do
        before do 
          @char = double
        end
        
        it "should cost 0 if same level" do
          cost = Ffg.characteristic_xp_cost(@char, 1, 1)
          expect(cost).to eq 0
        end

        it "should cost 10x new level - 1" do
          cost = Ffg.characteristic_xp_cost(@char, 0, 1)
          expect(cost).to eq 10
        end
        
        it "should cost 10x new level - 3" do
          cost = Ffg.characteristic_xp_cost(@char, 2, 3)
          expect(cost).to eq 30
        end
        
        it "should handle multiple levels" do
          cost = Ffg.characteristic_xp_cost(@char, 3, 5)
          expect(cost).to eq 90
        end        
      end
      
      describe :skill_xp_cost do
        before do 
          @char = double
          allow(Ffg).to receive(:is_career_skill?) { false }
        end
        
        it "should cost 0 if same level" do
          cost = Ffg.skill_xp_cost(@char, "Melee", 1, 1)
          expect(cost).to eq 0
        end
        
        it "should cost 5x new level for career skill" do
          expect(Ffg).to receive(:is_career_skill?).with(@char, "Melee") { true }
          cost = Ffg.skill_xp_cost(@char, "Melee", 0, 1)
          expect(cost).to eq 5
        end
        
        it "should cost 5 extra for non-career skill" do
          expect(Ffg).to receive(:is_career_skill?).with(@char, "Melee") { false }
          cost = Ffg.skill_xp_cost(@char, "Melee", 0, 1)
          expect(cost).to eq 10
        end

        it "should cost 5x for new level - career 3" do
          expect(Ffg).to receive(:is_career_skill?).with(@char, "Melee") { true }
          cost = Ffg.skill_xp_cost(@char, "Melee", 2, 3)
          expect(cost).to eq 15
        end
              
        it "should cost 5 extra for new level - non-career 3" do
          expect(Ffg).to receive(:is_career_skill?).with(@char, "Melee") { false }
          cost = Ffg.skill_xp_cost(@char, "Melee", 2, 3)
          expect(cost).to eq 20
        end
        
        it "should handle multiple levels" do
          expect(Ffg).to receive(:is_career_skill?).with(@char, "Melee") { true }
          cost = Ffg.skill_xp_cost(@char, "Melee", 2, 4)
          expect(cost).to eq 15+20
        end
      end
      
      describe :specialization_xp_cost do
        before do 
          @char = double
          allow(Ffg).to receive(:is_career_specialization?) { true }
        end
        
        it "should be free for first spec" do
          cost = Ffg.specialization_xp_cost(@char, "Soldier", 0)
          expect(cost).to eq 0
        end
        
        it "should cost 20 for first extra one" do
          cost = Ffg.specialization_xp_cost(@char, "Soldier", 1)
          expect(cost).to eq 20
        end
        
        it "should cost 10 extra for non-career spec" do
          expect(Ffg).to receive(:is_career_specialization?).with(@char, "Soldier") { false }
          cost = Ffg.specialization_xp_cost(@char, "Soldier", 1)
          expect(cost).to eq 30
        end
        
        it "should cost 10x num of specs for existing ones" do
          cost = Ffg.specialization_xp_cost(@char, "Soldier", 2)
          expect(cost).to eq 30
        end
        
        it "should cost 10 extra for non-career spec w existing ones" do
          expect(Ffg).to receive(:is_career_specialization?).with(@char, "Soldier") { false }
          cost = Ffg.specialization_xp_cost(@char, "Soldier", 2)
          expect(cost).to eq 40
        end
      end
      
      describe :talent_xp_cost do
        before do 
          @char = double
        end
        
        it "should cost tier x 5 for non-ranked talent" do
          expect(Ffg).to receive(:find_talent_config).with("Smart") { { "tier" => 2, "ranked" => false } }
          cost = Ffg.talent_xp_cost("Smart", 0, 1)
          expect(cost).to eq 10
        end
        
        it "should cost tier x 5 for non-ranked talent - tier 3" do
          expect(Ffg).to receive(:find_talent_config).with("Smart") { { "tier" => 3, "ranked" => false } }
          cost = Ffg.talent_xp_cost("Smart", 0, 1)
          expect(cost).to eq 15
        end
        
        it "should cost tier x 5 for first rank of ranked talent" do
          expect(Ffg).to receive(:find_talent_config).with("Smart") { { "tier" => 1, "ranked" => true } }
          cost = Ffg.talent_xp_cost("Smart", 0, 1)
          expect(cost).to eq 5
        end
        
        it "should cost same as tier 2 for second rank of tier 1 talent" do
          expect(Ffg).to receive(:find_talent_config).with("Smart") { { "tier" => 1, "ranked" => true } }
          cost = Ffg.talent_xp_cost("Smart", 1, 2)
          expect(cost).to eq 10

        end
        
        it "should cost same as tier 4 for second rank of tier 3 talent" do
          expect(Ffg).to receive(:find_talent_config).with("Smart") { { "tier" => 3, "ranked" => true } }
          cost = Ffg.talent_xp_cost("Smart", 1, 2)
          expect(cost).to eq 20
        end
        
        it "should handle multiple ranks at once" do
          expect(Ffg).to receive(:find_talent_config).with("Smart") { { "tier" => 1, "ranked" => true } }
          cost = Ffg.talent_xp_cost("Smart", 0, 3)
          expect(cost).to eq 5+10+15
        end
        
        it "should handle multiple ranks at once - tier 2" do
          expect(Ffg).to receive(:find_talent_config).with("Smart") { { "tier" => 2, "ranked" => true } }
          cost = Ffg.talent_xp_cost("Smart", 0, 3)
          expect(cost).to eq 10+15+20
        end
      end
    end
  end
end

        
