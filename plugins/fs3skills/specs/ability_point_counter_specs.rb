module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        allow(Global).to receive(:read_config).with("fs3skills", "free_languages") { 3 }
      end
      
      describe :points_on_attrs do
        before do
          @char = double
        end
        
        it "should count anything above average" do
          attrs = [ FS3Attribute.new(rating: 5), 
                    FS3Attribute.new(rating: 2), 
                    FS3Attribute.new(rating: 3),
                    FS3Attribute.new(rating: 4) ]
          allow(@char).to receive(:fs3_attributes) { attrs }
          expect(AbilityPointCounter.points_on_attrs(@char)).to eq 12
        end
        
        it "should not count average or below average" do
          attrs = [ FS3Attribute.new(rating: 1), 
                    FS3Attribute.new(rating: 2), 
                    FS3Attribute.new(rating: 2),
                    FS3Attribute.new(rating: 2) ]
          allow(@char).to receive(:fs3_attributes) { attrs }
          expect(AbilityPointCounter.points_on_attrs(@char)).to eq 0
        end
      end
      
      describe :points_on_action do
        before do
          @char = double
        end
        
        it "should count anything above everyman" do
          action = [ FS3ActionSkill.new(rating: 2), 
                     FS3ActionSkill.new(rating: 3), 
                     FS3ActionSkill.new(rating: 4),
                     FS3ActionSkill.new(rating: 5) ]
          allow(@char).to receive(:fs3_action_skills) { action }
          expect(AbilityPointCounter.points_on_action(@char)).to eq 10
        end
        
        it "should not count everyman or poor" do
          action = [ FS3ActionSkill.new(rating: 1), 
                     FS3ActionSkill.new(rating: 1), 
                     FS3ActionSkill.new(rating: 1),
                     FS3ActionSkill.new(rating: 0) ]
          allow(@char).to receive(:fs3_action_skills) { action }
          expect(AbilityPointCounter.points_on_action(@char)).to eq 0
        end
      end

      describe :points_on_background do
        before do
          @char = double
          allow(Global).to receive(:read_config).with("fs3skills", "free_backgrounds") { 5 }
        end
        
        it "should count past the free ones" do
          bg = [ FS3BackgroundSkill.new(rating: 3), 
                 FS3BackgroundSkill.new(rating: 3), 
                 FS3BackgroundSkill.new(rating: 2) ]
          allow(@char).to receive(:fs3_background_skills) { bg }
          expect(AbilityPointCounter.points_on_background(@char)).to eq 3
        end
        
        it "should not count if below free ones" do
          bg = [ FS3BackgroundSkill.new(rating: 2), 
                 FS3BackgroundSkill.new(rating: 1), 
                 FS3BackgroundSkill.new(rating: 1) ]
          allow(@char).to receive(:fs3_background_skills) { bg }
          expect(AbilityPointCounter.points_on_background(@char)).to eq 0
        end
      end
      
      describe :points_on_language do
        before do
          @char = double
          allow(Global).to receive(:read_config).with("fs3skills", "free_languages") { 4 }
        end
        
        it "should count past the free ones" do
          lang = [ FS3Language.new(rating: 3), 
                   FS3Language.new(rating: 3), 
                   FS3Language.new(rating: 2) ]
          allow(@char).to receive(:fs3_languages) { lang }
          expect(AbilityPointCounter.points_on_language(@char)).to eq 4
        end
        
        it "should not count if below free ones" do
          lang = [ FS3Language.new(rating: 2), 
                   FS3Language.new(rating: 1) ]
          allow(@char).to receive(:fs3_languages) { lang }
          expect(AbilityPointCounter.points_on_language(@char)).to eq 0
        end
      end
      
      describe :points_on_specialties do
        before do
          @char = double
        end
        
        it "should count abilities with more than one specialty" do
          action = [ FS3ActionSkill.new(specialties: [ "A", "B" ]), 
                     FS3ActionSkill.new(specialties: ["C", "D", "E"] ) ]
          allow(@char).to receive(:fs3_action_skills) { action }
          expect(AbilityPointCounter.points_on_specialties(@char)).to eq 3
        end
        
        it "should not count first specialties" do
          action = [ FS3ActionSkill.new(specialties: [ "A" ]), 
                     FS3ActionSkill.new(specialties: [ "C" ] ) ]
          allow(@char).to receive(:fs3_action_skills) { action }
          expect(AbilityPointCounter.points_on_specialties(@char)).to eq 0
        end
      end
      
    end
  end
end
