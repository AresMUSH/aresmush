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
          Global.stub(:read_config).with("fs3skills", "attributes") { [ ] }
          Global.stub(:read_config).with("fs3skills", "action_skills") { [ ] }
          
          Global.stub(:read_config).with("fs3skills", "allow_unskilled_action_skills") { true }
          
          @char = double
        end
        
        it "should include Everyone skills" do
          @char.stub(:group).with("Position") { "Other" }
          @char.stub(:group).with("Faction") { "Other" }
          skills = { "A" => 2, "B" => 3 }
          StartingSkills.get_skills_for_char(@char).should eq skills
        end
        
        it "should include matching group skills" do
          @char.stub(:group).with("Position") { "Pilot" }
          @char.stub(:group).with("Faction") { "Other" }
          skills = { "A" => 2, "B" => 3, "C" => 4 }
          StartingSkills.get_skills_for_char(@char).should eq skills
        end

        it "should include the higher skill if multiple matches" do
          @char.stub(:group).with("Position") { "Pilot" }
          @char.stub(:group).with("Faction") { "Navy" }
          skills = { "A" => 2, "B" => 3, "C" => 4 }
          StartingSkills.get_skills_for_char(@char).should eq skills
        end
        
        it "should include default attributes" do
          @char.stub(:group).with("Position") { "Other" }
          @char.stub(:group).with("Faction") { "Other" }
          Global.stub(:read_config).with("fs3skills", "attributes") { [ { 'name' => 'Brawn' }, { 'name' => 'Presence' } ] }
          skills = { "A" => 2, "B" => 3, "Brawn" => 1, "Presence" => 1 }
          StartingSkills.get_skills_for_char(@char).should eq skills        
        end
        
        it "should include default action skills when unskilled allowed" do
          @char.stub(:group).with("Position") { "Other" }
          @char.stub(:group).with("Faction") { "Other" }
          Global.stub(:read_config).with("fs3skills", "action_skills") { [ { 'name' => 'Melee' } ] }
          Global.stub(:read_config).with("fs3skills", "allow_unskilled_action_skills") { true }
          skills = { "A" => 2, "B" => 3, "Melee" => 0 }
          StartingSkills.get_skills_for_char(@char).should eq skills        
        end

        it "should include default action skills when unskilled not allowed" do
          @char.stub(:group).with("Position") { "Other" }
          @char.stub(:group).with("Faction") { "Other" }
          Global.stub(:read_config).with("fs3skills", "action_skills") { [ { 'name' => 'Melee' } ] }
          Global.stub(:read_config).with("fs3skills", "allow_unskilled_action_skills") { false }
          skills = { "A" => 2, "B" => 3, "Melee" => 1 }
          StartingSkills.get_skills_for_char(@char).should eq skills        
        end
      end
      
      describe :get_specialties_for_char do
        before do 
          starting_skills = 
          {
            "Everyone" => { "skills" => { "A" => 2, "B" => 3 }, "specialties" => { "A" => [ "X", "Y" ], "B" => [ "Z" ] } },
            "Position" => { "Pilot" => { "skills" => { "C" => 4 }, "specialties" => { "A" => [ "X", "U" ] } } },
            "Faction" => { "Navy" => { "skills" => { "C" => 2 }, "specialties" => { "B" => [ "W" ] } } }
          }
          Global.stub(:read_config).with("fs3skills", "starting_skills") { starting_skills }
          @char = double
        end
        
        it "should include Everyone skills" do
          @char.stub(:group).with("Position") { "Other" }
          @char.stub(:group).with("Faction") { "Other" }
          specs = { "A" => [ "X", "Y" ], "B" => [ "Z" ] }
          StartingSkills.get_specialties_for_char(@char).should eq specs
        end
        
        it "should include matching group skills" do
          @char.stub(:group).with("Position") { "Pilot" }
          @char.stub(:group).with("Faction") { "Other" }
          specs = { "A" => [ "X", "Y", "U" ], "B" => [ "Z" ] }
          StartingSkills.get_specialties_for_char(@char).should eq specs
        end

        it "should include the higher skill if multiple matches" do
          @char.stub(:group).with("Position") { "Pilot" }
          @char.stub(:group).with("Faction") { "Navy" }
          specs = { "A" => [ "X", "Y", "U" ], "B" => [ "Z", "W" ] }
          StartingSkills.get_specialties_for_char(@char).should eq specs
        end
        
      end
    end
  end
end