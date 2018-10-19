module AresMUSH
  module Ffg
    describe Ffg do 
      
      before do
        stub_translate_for_testing
      end      
      
      describe :talent_tree_balanced_for_add do
        before do
          @char = double
        end

        it "should always return balanced for tier 1" do
          balanced = Ffg.talent_tree_balanced_for_add(@char, 1)
          expect(balanced).to eq true
        end

        it "should succeed if room at new tier" do
          talents = [ FfgTalent.new(tier: 1, rating: 1), FfgTalent.new(tier: 1, rating: 1) ]
          allow(@char).to receive(:ffg_talents) { talents }
          balanced = Ffg.talent_tree_balanced_for_add(@char, 2)
          expect(balanced).to eq true
        end

        it "should fail if no room at new tier" do
          talents = [ FfgTalent.new(tier: 1, rating: 1) ]
          allow(@char).to receive(:ffg_talents) { talents }
          balanced = Ffg.talent_tree_balanced_for_add(@char, 2)
          expect(balanced).to eq false
        end
        
        it "should fail if not more than one slot open" do
          talents = [ FfgTalent.new(tier: 1, rating: 1), FfgTalent.new(tier: 1, rating: 1), FfgTalent.new(tier: 2, rating: 1) ]
          allow(@char).to receive(:ffg_talents) { talents }
          balanced = Ffg.talent_tree_balanced_for_add(@char, 2)
          expect(balanced).to eq false
        end
        
        it "should account for ratings in tier filling up" do
          talents = [ FfgTalent.new(tier: 2, rating: 1), FfgTalent.new(tier: 1, rating: 3, ranked: true), FfgTalent.new(tier: 1, rating: 1) ]
          allow(@char).to receive(:ffg_talents) { talents }
          balanced = Ffg.talent_tree_balanced_for_add(@char, 2)
          expect(balanced).to eq false
        end
        
        it "should account for ratings in tier providing foundation" do
          talents = [ FfgTalent.new(tier: 1, rating: 1), FfgTalent.new(tier: 1, rating: 1), FfgTalent.new(tier: 1, rating: 1), FfgTalent.new(tier: 1, rating: 2, ranked: true) ]
          allow(@char).to receive(:ffg_talents) { talents }
          balanced = Ffg.talent_tree_balanced_for_add(@char, 2)
          expect(balanced).to eq true
        end
        
      end
      
      describe :talent_tree_balanced_for_remove do
        before do
          @char = double
        end

        it "should always return balanced for tier 5" do
          balanced = Ffg.talent_tree_balanced_for_remove(@char, 5)
          expect(balanced).to eq true
        end

        it "should succeed if extra talents" do
          talents = [ FfgTalent.new(tier: 2, rating: 1), FfgTalent.new(tier: 2, rating: 1), FfgTalent.new(tier: 2, rating: 1), FfgTalent.new(tier: 3, rating: 1) ]
          allow(@char).to receive(:ffg_talents) { talents }
          balanced = Ffg.talent_tree_balanced_for_remove(@char, 2)
          expect(balanced).to eq true
        end

        it "should fail if removing talent would make it short" do
          talents = [ FfgTalent.new(tier: 2, rating: 1), FfgTalent.new(tier: 2, rating: 1), FfgTalent.new(tier: 3, rating: 1) ]
          allow(@char).to receive(:ffg_talents) { talents }
          balanced = Ffg.talent_tree_balanced_for_remove(@char, 2)
          expect(balanced).to eq false
        end
        
        it "should account for ratings in tier filling up" do
          talents = [ FfgTalent.new(tier: 2, rating: 1), FfgTalent.new(tier: 1, rating: 3, ranked: true), FfgTalent.new(tier: 1, rating: 1), FfgTalent.new(tier: 1, rating: 2), FfgTalent.new(tier: 3, rating: 1) ]
          allow(@char).to receive(:ffg_talents) { talents }
          balanced = Ffg.talent_tree_balanced_for_remove(@char, 2)
          expect(balanced).to eq false
        end
        
        it "should account for ratings in tier providing foundation xxxx" do
          talents = [ FfgTalent.new(tier: 1, rating: 2, ranked: true), FfgTalent.new(tier: 2, rating: 1), FfgTalent.new(tier: 2, rating: 1), FfgTalent.new(tier: 3, rating: 1) ]
          allow(@char).to receive(:ffg_talents) { talents }
          balanced = Ffg.talent_tree_balanced_for_remove(@char, 2)
          expect(balanced).to eq true
        end
        
      end
    end
  end
end

        
