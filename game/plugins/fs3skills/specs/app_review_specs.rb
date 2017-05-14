module AresMUSH
  module FS3Skills
    describe FS3Skills do 
      
      before do
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :hook_review do
        before do 
          Global.stub(:read_config).with("fs3skills", "min_hooks") { 2 }
          @char = double
        end
        
        it "should error if too few hooks" do
          @char.stub(:fs3_hooks) { [ FS3RpHook.new() ] }
          review = FS3Skills.hook_review(@char)
          review.should eq "fs3skills.hooks_added                              chargen.not_enough"
        end
        
        it "should be OK if enough hooks" do
          @char.stub(:fs3_hooks) { [ FS3RpHook.new(), FS3RpHook.new() ] }
          review = FS3Skills.hook_review(@char)
          review.should eq "fs3skills.hooks_added                              chargen.ok"
        end
      end

      describe :backgrounds do
        before do 
          Global.stub(:read_config).with("fs3skills", "min_backgrounds") { 2 }
          @char = double
        end
        
        it "should error if too few bg skills" do
          @char.stub(:fs3_background_skills) { [ FS3BackgroundSkill.new() ] }
          review = FS3Skills.backgrounds_review(@char)
          review.should eq "fs3skills.backgrounds_added                        chargen.not_enough"
        end
        
        it "should be OK if enough bg skills" do
          @char.stub(:fs3_background_skills) { [ FS3BackgroundSkill.new(), FS3BackgroundSkill.new() ] }
          review = FS3Skills.backgrounds_review(@char)
          review.should eq "fs3skills.backgrounds_added                        chargen.ok"
        end
      end
      
      describe :ability_rating_check do
        before do 
          Global.stub(:read_config).with("fs3skills", "max_skills_above_4") { 2 }
          Global.stub(:read_config).with("fs3skills", "max_skills_above_6") { 1 }
          Global.stub(:read_config).with("fs3skills", "max_attr_above_3") { 2 }
          Global.stub(:read_config).with("fs3skills", "max_attr_above_4") { 1 }
          Global.stub(:read_config).with("fs3skills", "max_attributes") { 14 }
          @char = double
        end
        
        it "should error if too many skills above 6" do
          @char.stub(:fs3_attributes) { [] }
          @char.stub(:fs3_action_skills) { [ FS3ActionSkill.new(rating: 7), 
                                             FS3ActionSkill.new(rating: 8) ] }
          review = FS3Skills.ability_rating_review(@char)
          review.should eq "fs3skills.ability_ratings_check%r%Tfs3skills.action_skills_above"
        end

        it "should error if too many skills above 4" do
          @char.stub(:fs3_attributes) { [] }
          @char.stub(:fs3_action_skills) { [ FS3ActionSkill.new(rating: 7),
                                             FS3ActionSkill.new(rating: 5),
                                             FS3ActionSkill.new(rating: 5) ] }
          review = FS3Skills.ability_rating_review(@char)
          review.should eq "fs3skills.ability_ratings_check%r%Tfs3skills.action_skills_above"
        end
        
        it "should error if too many points on attrs" do
          @char.stub(:fs3_action_skills) { [] }
          @char.stub(:fs3_attributes) { [ FS3Attribute.new(rating: 3),
                                             FS3Attribute.new(rating: 4),
                                             FS3Attribute.new(rating: 3),
                                             FS3Attribute.new(rating: 3),
                                             FS3Attribute.new(rating: 4),
                                             FS3Attribute.new(rating: 3) ] }
          review = FS3Skills.ability_rating_review(@char)
          review.should eq "fs3skills.ability_ratings_check%r%Tfs3skills.too_many_attributes"
        end
        
        it "should error if too many attrs above 3" do
          @char.stub(:fs3_action_skills) { [] }
          @char.stub(:fs3_attributes) { [ FS3Attribute.new(rating: 4),
                                             FS3Attribute.new(rating: 4),
                                             FS3Attribute.new(rating: 5) ] }
          review = FS3Skills.ability_rating_review(@char)
          review.should eq "fs3skills.ability_ratings_check%r%Tfs3skills.attributes_above"
        end
        
        it "should error if too many attrs above 4" do
          @char.stub(:fs3_action_skills) { [] }
          @char.stub(:fs3_attributes) { [ FS3Attribute.new(rating: 5),
                                             FS3Attribute.new(rating: 5) ] }
          review = FS3Skills.ability_rating_review(@char)
          review.should eq "fs3skills.ability_ratings_check%r%Tfs3skills.attributes_above"
        end
        
        it "should be OK if not too many high abilities" do
          @char.stub(:fs3_attributes) { [ FS3Attribute.new(rating: 3),
                                             FS3Attribute.new(rating: 4),
                                             FS3Attribute.new(rating: 2) ] }
         @char.stub(:fs3_action_skills) { [ FS3ActionSkill.new(rating: 7),
                                            FS3ActionSkill.new(rating: 4),
                                            FS3ActionSkill.new(rating: 3) ] }
          review = FS3Skills.ability_rating_review(@char)
          review.should eq "fs3skills.ability_ratings_check                    chargen.ok"
        end
      end
      
      
      describe :starting_language_review do
        before do 
          Global.stub(:read_config).with("fs3skills", "starting_languages") { ["English", "German"] }
          @char = double
        end

        it "should warn if missing a starting language" do
          FS3Skills.stub(:ability_rating).with(@char, "English") { 3 }
          FS3Skills.stub(:ability_rating).with(@char, "German") { 0 }
          review = FS3Skills.starting_language_review(@char)
          review.should eq "fs3skills.language_check                           chargen.are_you_sure"
        end
        
        it "should be OK if all languages present" do
          FS3Skills.stub(:ability_rating).with(@char, "English") { 3 }
          FS3Skills.stub(:ability_rating).with(@char, "German") { 3 }
          review = FS3Skills.starting_language_review(@char)
          review.should eq "fs3skills.language_check                           chargen.ok"
        end
      end

      describe :starting_skills_check do
        before do 
          @char = double
          @char.stub(:fs3_action_skills) { [] }
          StartingSkills.stub(:get_skills_for_char) { { "A" => 2, "B" => 3 }}
          StartingSkills.stub(:get_specialties_for_char) { { "A" => [ "X" ] }}
          FS3Skills.stub(:ability_rating).with(@char, "A") { 3 }
          FS3Skills.stub(:ability_rating).with(@char, "B") { 3 }
          FS3Skills.stub(:action_skill_config) { {} }
        end

        it "should warn if missing a starting skill" do
          FS3Skills.stub(:ability_rating).with(@char, "B") { 0 }
          review = FS3Skills.starting_skills_check(@char)
          review.should eq "fs3skills.starting_skills_check%r%Tfs3skills.missing_starting_skill"
        end
        
        it "should be OK if all skills present" do
          review = FS3Skills.starting_skills_check(@char)
          review.should eq "fs3skills.starting_skills_check                    chargen.ok"
        end
        
        it "should warn if missing a required specialty and over amateur" do
          config = { "specialties" => [ "A" ] }
          FS3Skills.stub(:action_skill_config) { config }
          @char.stub(:fs3_action_skills) { [ FS3ActionSkill.new(name: "Firearms", rating: 3)] }
          review = FS3Skills.starting_skills_check(@char)
          review.should eq "fs3skills.starting_skills_check%r%Tfs3skills.missing_specialty"
        end
        
        it "should warn if missing a required specialty and under amateur" do
          config = { "specialties" => [ "A" ] }
          FS3Skills.stub(:action_skill_config) { config }
          @char.stub(:fs3_action_skills) { [ FS3ActionSkill.new(name: "Firearms", rating: 2)] }
          review = FS3Skills.starting_skills_check(@char)
          review.should eq "fs3skills.starting_skills_check                    chargen.ok"
        end
        
        it "should be OK if specialty present" do
          config = { "specialties" => [ "A" ] }
          FS3Skills.stub(:action_skill_config) { config }
          @char.stub(:fs3_action_skills) { [ FS3ActionSkill.new(name: "Firearms", specialties: [ "X" ])] }
          review = FS3Skills.starting_skills_check(@char)
          review.should eq "fs3skills.starting_skills_check                    chargen.ok"
        end
        
        it "should warn if missing group specialty" do
          @char.stub(:fs3_action_skills) { [ FS3ActionSkill.new(name: "A", rating: 3)] }
          review = FS3Skills.starting_skills_check(@char)
          review.should eq "fs3skills.starting_skills_check%r%Tfs3skills.missing_group_specialty"
        end

        it "should not warn if group specialty present" do
          skill = FS3ActionSkill.new(name: "A", rating: 3, specialties: [ 'X' ])
          @char.stub(:fs3_action_skills) { [ skill ] }
          review = FS3Skills.starting_skills_check(@char)
          review.should eq "fs3skills.starting_skills_check                    chargen.ok"
        end
      end
    end
  end
end