module AresMUSH
  module FS3Skills
    describe FS3Skills do 
      
      before do
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :get_skills_for_char do
        before do 
          starting_skills = 
          {
            "Everyone" => { "skills" => { "A" => 2, "B" => 3 } },
            "Position" => { "Pilot" => { "skills" => { "C" => 4 } } },
            "Faction" => { "Navy" => { "skills" => { "C" => 2 } } }
          }
          Global.stub(:read_config).with("fs3skills", "starting_skills") { starting_skills }
          @char = double
        end
        
        it "should include Everyone skills" do
          @char.stub(:group_value).with("Position") { "Other" }
          @char.stub(:group_value).with("Faction") { "Other" }
          skills = { "A" => 2, "B" => 3 }
          StartingSkills.get_skills_for_char(@char).should eq skills
        end
        
        it "should include matching group skills" do
          @char.stub(:group_value).with("Position") { "Pilot" }
          @char.stub(:group_value).with("Faction") { "Other" }
          skills = { "A" => 2, "B" => 3, "C" => 4 }
          StartingSkills.get_skills_for_char(@char).should eq skills
        end

        it "should include the higher skill if multiple matches" do
          @char.stub(:group_value).with("Position") { "Pilot" }
          @char.stub(:group_value).with("Faction") { "Navy" }
          skills = { "A" => 2, "B" => 3, "C" => 4 }
          StartingSkills.get_skills_for_char(@char).should eq skills
        end
        
      end
    end
  end
end