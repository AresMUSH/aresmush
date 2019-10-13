module AresMUSH
  module FS3Skills
    describe FS3Skills do 
      
      before do
        stub_translate_for_testing
      end      

      describe :backgrounds do
        before do 
          allow(Global).to receive(:read_config).with("fs3skills", "min_backgrounds") { 2 }
          @char = double
        end
        
        it "should error if too few bg skills" do
          allow(@char).to receive(:fs3_background_skills) { [ FS3BackgroundSkill.new() ] }
          review = FS3Skills.backgrounds_review(@char)
          expect(review).to eq "fs3skills.backgrounds_added                        chargen.not_enough"
        end
        
        it "should be OK if enough bg skills" do
          allow(@char).to receive(:fs3_background_skills) { [ FS3BackgroundSkill.new(), FS3BackgroundSkill.new() ] }
          review = FS3Skills.backgrounds_review(@char)
          expect(review).to eq "fs3skills.backgrounds_added                        chargen.ok"
        end
      end
      
      describe :ability_rating_check do
        before do 
          allow(Global).to receive(:read_config).with("fs3skills", "max_skills_at_or_above") { { 5 => 2, 7 => 1 } }
          allow(Global).to receive(:read_config).with("fs3skills", "max_attrs_at_or_above") { { 4 => 2, 5 => 1 } }
          allow(Global).to receive(:read_config).with("fs3skills", "max_points_on_attrs") { 14 }
          allow(Global).to receive(:read_config).with("fs3skills", "max_points_on_action") { 20 }
          @char = double
        end
        
        it "should error if too many skills above 6" do
          allow(@char).to receive(:fs3_attributes) { [] }
          allow(@char).to receive(:fs3_action_skills) { [ FS3ActionSkill.new(rating: 7), 
                                             FS3ActionSkill.new(rating: 8) ] }
          review = FS3Skills.ability_rating_review(@char)
          expect(review).to eq "fs3skills.ability_ratings_check%r%Tfs3skills.action_skills_above"
        end

        it "should error if too many skills above 4" do
          allow(@char).to receive(:fs3_attributes) { [] }
          allow(@char).to receive(:fs3_action_skills) { [ FS3ActionSkill.new(rating: 7),
                                             FS3ActionSkill.new(rating: 5),
                                             FS3ActionSkill.new(rating: 5) ] }
          review = FS3Skills.ability_rating_review(@char)
          expect(review).to eq "fs3skills.ability_ratings_check%r%Tfs3skills.action_skills_above"
        end
        
        it "should error if too many points on attrs" do
          allow(@char).to receive(:fs3_action_skills) { [] }
          allow(@char).to receive(:fs3_attributes) { [ FS3Attribute.new(rating: 3),
                                             FS3Attribute.new(rating: 4),
                                             FS3Attribute.new(rating: 3),
                                             FS3Attribute.new(rating: 3),
                                             FS3Attribute.new(rating: 4),
                                             FS3Attribute.new(rating: 3) ] }
          review = FS3Skills.ability_rating_review(@char)
          expect(review).to eq "fs3skills.ability_ratings_check%r%Tfs3skills.too_many_attributes"
        end
        
        it "should error if too many points on action skills" do
          allow(@char).to receive(:fs3_attributes) { [] }
          allow(@char).to receive(:fs3_action_skills) { [ FS3ActionSkill.new(rating: 7),
                                             FS3ActionSkill.new(rating: 5),
                                             FS3ActionSkill.new(rating: 4),
                                             FS3ActionSkill.new(rating: 4),
                                             FS3ActionSkill.new(rating: 4),
                                             FS3ActionSkill.new(rating: 4) ] }
          review = FS3Skills.ability_rating_review(@char)
          expect(review).to eq "fs3skills.ability_ratings_check%r%Tfs3skills.too_many_action_skills"
        end
        
        it "should error if too many attrs above 3" do
          allow(@char).to receive(:fs3_action_skills) { [] }
          allow(@char).to receive(:fs3_attributes) { [ FS3Attribute.new(rating: 4),
                                             FS3Attribute.new(rating: 4),
                                             FS3Attribute.new(rating: 5) ] }
          review = FS3Skills.ability_rating_review(@char)
          expect(review).to eq "fs3skills.ability_ratings_check%r%Tfs3skills.attributes_above"
        end
        
        it "should error if too many attrs above 4" do
          allow(@char).to receive(:fs3_action_skills) { [] }
          allow(@char).to receive(:fs3_attributes) { [ FS3Attribute.new(rating: 5),
                                             FS3Attribute.new(rating: 5) ] }
          review = FS3Skills.ability_rating_review(@char)
          expect(review).to eq "fs3skills.ability_ratings_check%r%Tfs3skills.attributes_above"
        end
        
        it "should be OK if not too many high abilities" do
          allow(@char).to receive(:fs3_attributes) { [ FS3Attribute.new(rating: 3),
                                             FS3Attribute.new(rating: 4),
                                             FS3Attribute.new(rating: 2) ] }
         allow(@char).to receive(:fs3_action_skills) { [ FS3ActionSkill.new(rating: 7),
                                            FS3ActionSkill.new(rating: 4),
                                            FS3ActionSkill.new(rating: 3) ] }
          review = FS3Skills.ability_rating_review(@char)
          expect(review).to eq "fs3skills.ability_ratings_check                    chargen.ok"
        end
      end

      describe :starting_skills_check do
        before do 
          @char = double
          allow(@char).to receive(:fs3_action_skills) { [] }
          allow(StartingSkills).to receive(:get_skills_for_char) { { "A" => 2, "B" => 3 }}
          allow(StartingSkills).to receive(:get_specialties_for_char) { { "A" => [ "X" ] }}
          allow(FS3Skills).to receive(:ability_rating).with(@char, "A") { 3 }
          allow(FS3Skills).to receive(:ability_rating).with(@char, "B") { 3 }
          allow(FS3Skills).to receive(:action_skill_config) { {} }
        end

        it "should warn if missing a starting skill" do
          allow(FS3Skills).to receive(:ability_rating).with(@char, "B") { 0 }
          review = FS3Skills.starting_skills_check(@char)
          expect(review).to eq "fs3skills.starting_skills_check%r%Tfs3skills.missing_starting_skill"
        end
        
        it "should be OK if all skills present" do
          review = FS3Skills.starting_skills_check(@char)
          expect(review).to eq "fs3skills.starting_skills_check                    chargen.ok"
        end
        
        it "should warn if missing a required specialty and over amateur" do
          config = { "specialties" => [ "A" ] }
          allow(FS3Skills).to receive(:action_skill_config) { config }
          allow(@char).to receive(:fs3_action_skills) { [ FS3ActionSkill.new(name: "Firearms", rating: 3)] }
          review = FS3Skills.starting_skills_check(@char)
          expect(review).to eq "fs3skills.starting_skills_check%r%Tfs3skills.missing_specialty"
        end
        
        it "should warn if missing a required specialty and under amateur" do
          config = { "specialties" => [ "A" ] }
          allow(FS3Skills).to receive(:action_skill_config) { config }
          allow(@char).to receive(:fs3_action_skills) { [ FS3ActionSkill.new(name: "Firearms", rating: 2)] }
          review = FS3Skills.starting_skills_check(@char)
          expect(review).to eq "fs3skills.starting_skills_check                    chargen.ok"
        end
        
        it "should be OK if specialty present" do
          config = { "specialties" => [ "A" ] }
          allow(FS3Skills).to receive(:action_skill_config) { config }
          allow(@char).to receive(:fs3_action_skills) { [ FS3ActionSkill.new(name: "Firearms", specialties: [ "X" ])] }
          review = FS3Skills.starting_skills_check(@char)
          expect(review).to eq "fs3skills.starting_skills_check                    chargen.ok"
        end
        
        it "should warn if missing group specialty" do
          allow(@char).to receive(:fs3_action_skills) { [ FS3ActionSkill.new(name: "A", rating: 3)] }
          review = FS3Skills.starting_skills_check(@char)
          expect(review).to eq "fs3skills.starting_skills_check%r%Tfs3skills.missing_group_specialty"
        end

        it "should not warn if group specialty present" do
          skill = FS3ActionSkill.new(name: "A", rating: 3, specialties: [ 'X' ])
          allow(@char).to receive(:fs3_action_skills) { [ skill ] }
          review = FS3Skills.starting_skills_check(@char)
          expect(review).to eq "fs3skills.starting_skills_check                    chargen.ok"
        end
      end
      

      describe :unusual_skills_check do
        before do 
          @char = double
          allow(@char).to receive(:fs3_background_skills) { [] }
          allow(@char).to receive(:fs3_action_skills) { [] }
          allow(@char).to receive(:fs3_languages) { [] }
          allow(Global).to receive(:read_config).with("fs3skills", "unusual_skills") { [ "A" ] }
        end

        it "should warn if char has an unusual action skill above everyman" do
          allow(@char).to receive(:fs3_action_skills) { [ FS3ActionSkill.new(name: "A", rating: 2) ] }
          review = FS3Skills.unusual_skills_check(@char)
          expect(review).to eq "fs3skills.unusual_abilities_check%r%Tfs3skills.unusual_skill"
        end

        it "should not warn if char has an unusual action skill at everyman" do
          allow(@char).to receive(:fs3_action_skills) { [ FS3ActionSkill.new(name: "A", rating: 1) ] }
          review = FS3Skills.unusual_skills_check(@char)
          expect(review).to eq "fs3skills.unusual_abilities_check                  chargen.ok"
        end
        
        it "should warn if char has an unusual background skill" do
          allow(@char).to receive(:fs3_background_skills) { [ FS3BackgroundSkill.new(name: "A", rating: 1) ] }
          review = FS3Skills.unusual_skills_check(@char)
          expect(review).to eq "fs3skills.unusual_abilities_check%r%Tfs3skills.unusual_skill"
        end
        
        it "should warn if char has an unusual language skill" do
          allow(@char).to receive(:fs3_languages) { [ FS3Language.new(name: "A", rating: 1) ] }
          review = FS3Skills.unusual_skills_check(@char)
          expect(review).to eq "fs3skills.unusual_abilities_check%r%Tfs3skills.unusual_skill"
        end
        
        it "should warn if char has a high background skill" do
          allow(@char).to receive(:fs3_background_skills) { [ FS3BackgroundSkill.new(name: "B", rating: 2)]}
          review = FS3Skills.unusual_skills_check(@char)
          expect(review).to eq "fs3skills.unusual_abilities_check%r%Tfs3skills.high_bg"
        end
        
        it "should be OK if no unusual skills present" do
          review = FS3Skills.unusual_skills_check(@char)
          expect(review).to eq "fs3skills.unusual_abilities_check                  chargen.ok"
        end
        
      end
      
    end
  end
end
