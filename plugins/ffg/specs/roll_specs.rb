module AresMUSH
  module Ffg
    describe Ffg do 
      
      before do
        stub_translate_for_testing
      end      

      describe :parse_roll_string do
        
        it "should handle a skill" do
          params = Ffg.parse_roll_string("Melee")
          expect(params.skill).to eq "Melee"
        end
        
        it "should handle a skill plus some extra dice" do
          params = Ffg.parse_roll_string("Melee+2B")
          expect(params.skill).to eq "Melee"
          expect(params.boost).to eq 2
        end
        
        it "should handle just dice" do
          params = Ffg.parse_roll_string("3A+2B")
          expect(params.boost).to eq 2
          expect(params.ability).to eq 3
        end
      end
      
      describe :roll_ability do
        before do
          @char = double
        end
        
        it "should roll the number of dice" do
          expect(Ffg).to receive(:roll_boost_die) { [ 'S', 'A' ] }
          expect(Ffg).to receive(:roll_boost_die) { [ 'A' ] }
          expect(Ffg).to receive(:roll_difficulty_die) { [ 'F' ] }
          expect(Ffg).to receive(:roll_difficulty_die) { [ 'T', 'F' ] }
          expect(Ffg).to receive(:roll_difficulty_die) { [ 'F' ] }
          
          result = Ffg.roll_ability(@char, "2B+3D")
          expect(result).to eq [ 'A', 'A', 'F', 'F', 'F', 'S', 'T' ]
        end
        
        it "should add skill dice" do
          expect(Ffg).to receive(:roll_difficulty_die) { [ 'F' ] }
          expect(Ffg).to receive(:roll_difficulty_die) { [ 'T' ] }
          expect(Ffg).to receive(:roll_ability_die) { [ 'S' ] }
          expect(Ffg).to receive(:roll_ability_die) { [ 'A' ] }
          expect(Ffg).to receive(:roll_ability_die) { [ 'A', 'A' ] }
          expect(Ffg).to receive(:roll_proficiency_die) { [ 'S' ] }
          expect(Ffg).to receive(:find_skill_dice).with(@char, 'Melee') { { ability: 2, proficiency: 1 }}

          result = Ffg.roll_ability(@char, "Melee+1A+2D")
          expect(result).to eq [ 'A', 'A', 'A', 'F', 'S', 'S', 'T' ]
        end
      end
      
      describe :determine_outcome do
        it "should determine a success" do
          results = Ffg.determine_outcome([ 'S', 'S', 'F' ])
          expect(results.successful).to eq true
        end

        it "should determine a failure" do
          results = Ffg.determine_outcome([ 'S', 'F', 'F' ])
          expect(results.successful).to eq false
        end
        
        it "should determine a tie" do
          results = Ffg.determine_outcome([ 'S', 'F' ])
          expect(results.successful).to eq false
        end
        
        it "should count triumphs as successes" do
          results = Ffg.determine_outcome([ 'S', 'TRI', 'F' ])
          expect(results.successful).to eq true
        end

        it "should count despair as failure" do
          results = Ffg.determine_outcome([ 'S', 'DES' ])
          expect(results.successful).to eq false
        end

        it "should count net advantage" do
          results = Ffg.determine_outcome([ 'S', 'A', 'A', 'T', 'F' ])
          expect(results.net_advantage).to eq 1
          expect(results.net_threat).to eq 0
        end

        it "should count net threat" do
          results = Ffg.determine_outcome([ 'S', 'A', 'T', 'T', 'F' ])
          expect(results.net_advantage).to eq 0
          expect(results.net_threat).to eq 1
        end

        it "should track triumph" do
          results = Ffg.determine_outcome([ 'S', 'A', 'T', 'T', 'TRI' ])
          expect(results.triumph).to eq true
          expect(results.despair).to eq false
        end

        it "should track despair" do
          results = Ffg.determine_outcome([ 'S', 'A', 'T', 'T', 'F', 'DES' ])
          expect(results.despair).to eq true
          expect(results.triumph).to eq false
        end

      end
    end
  end
end

        
