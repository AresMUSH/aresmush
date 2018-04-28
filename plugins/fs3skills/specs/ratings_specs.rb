module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        FS3Skills.stub(:attr_names) { [ "Brawn", "Mind" ] }
        FS3Skills.stub(:action_skill_names) { [ "Firearms", "Demolitions" ] }
        FS3Skills.stub(:language_names) { [ "English", "Spanish" ] }
        FS3Skills.stub(:advantage_names) { [ "Rank", "Resources" ] }
      end
      
      describe :ability_rating do
        before do
          @char = double
          @languages = double
          @action_skills = double
          @bg_skills = double
          @attrs = double
          @advantages = double
          
          @advantages.stub(:find).with(name: "Resources") { [] }
          @advantages.stub(:find).with(name: "Rank") { [ FS3Advantage.new(name: "Rank", rating: 3 ) ]}
          
          @languages.stub(:find).with(name: "Spanish") { [] }
          @languages.stub(:find).with(name: "English") { [ FS3Language.new(name: "English", rating: 1 ) ] }
          
          @action_skills.stub(:find).with(name: "Firearms") {[ FS3ActionSkill.new(name: "Firearms", rating: 2 )] }
          @action_skills.stub(:find).with(name: "Demolitions") { [] }
          
          @bg_skills.stub(:find).with(name: "Basketweaving") { [ FS3BackgroundSkill.new(name: "Basketweaving", rating: 3 )] }
          @bg_skills.stub(:find).with(name: "Art") { [] }

          @attrs.stub(:find).with(name: "Brawn") { [ FS3Attribute.new(name: "Brawn", rating: 4 )] }
          @attrs.stub(:find).with(name: "Mind") { [] }
          
          @char.stub(:fs3_languages) { @languages }
          @char.stub(:fs3_attributes) { @attrs }
          @char.stub(:fs3_action_skills) { @action_skills }
          @char.stub(:fs3_background_skills) { @bg_skills }
          @char.stub(:fs3_advantages) { @advantages }
        end
        
        it "should get skills that exist" do
          FS3Skills.ability_rating(@char, "English").should eq 1
          FS3Skills.ability_rating(@char, "Firearms").should eq 2
          FS3Skills.ability_rating(@char, "Basketweaving").should eq 3
          FS3Skills.ability_rating(@char, "Brawn").should eq 4
          FS3Skills.ability_rating(@char, "Rank").should eq 3
        end
        
        it "should get skills that don't exit" do
          FS3Skills.ability_rating(@char, "Spanish").should eq 0
          FS3Skills.ability_rating(@char, "Demolitions").should eq 0
          FS3Skills.ability_rating(@char, "Mind").should eq 0
          FS3Skills.ability_rating(@char, "Art").should eq 0
          FS3Skills.ability_rating(@char, "Resources").should eq 0
        end
        
        it "should not search background skills for an action skill" do
          @bg_skills.stub(:find).with(name: "Demolitions") { [ FS3BackgroundSkill.new(name: "Demolitions", rating: 3 )] }
          FS3Skills.ability_rating(@char, "Demolitions").should eq 0
        end
        
        it "should not search background skills for a language" do
          @bg_skills.stub(:find).with(name: "Spanish") { [ FS3BackgroundSkill.new(name: "Spanish", rating: 3 )] }
          FS3Skills.ability_rating(@char, "Spanish").should eq 0
        end
      end
      
      describe :get_linked_attr do
        before do 
          skills = [ { "name" => "Firearms", "linked_attr" => "Brawn" } ]
          Global.stub(:read_config).with("fs3skills", "default_linked_attr") { "Wits" }
          Global.stub(:read_config).with("fs3skills", "action_skills") { skills }
          
        end
        
        it "should get linked for an action skill from the skill config" do
          FS3Skills.get_linked_attr("Firearms").should eq "Brawn"
        end

        it "should return nothing for attribute" do
          FS3Skills.get_linked_attr("Mind").should be_nil
        end
        
        it "should default for langs and background skills" do
          FS3Skills.get_linked_attr("Basketweaving").should eq "Wits"
          FS3Skills.get_linked_attr("Spanish").should eq "Wits"
        end
        
        it "should default for advantages" do
          FS3Skills.get_linked_attr("Rank").should eq "Wits"
        end
        
      end
    end
  end
end