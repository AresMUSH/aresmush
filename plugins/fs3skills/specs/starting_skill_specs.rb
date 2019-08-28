module AresMUSH
  module FS3Skills
    describe FS3Skills do 
      
      before do
        stub_translate_for_testing
      end
      
      describe :get_skills_for_char do
        before do 
          starting_skills = 
          {
            "Everyone" => { "skills" => { "A" => 2, "B" => 3 } },
            "Position" => { "Pilot" => { "skills" => { "C" => 4 } } },
            "Faction" => { "Navy" => { "skills" => { "C" => 2 } } }
          }
          allow(Global).to receive(:read_config).with("fs3skills", "starting_skills") { starting_skills }
          allow(Global).to receive(:read_config).with("fs3skills", "attributes") { [ ] }
          allow(Global).to receive(:read_config).with("fs3skills", "action_skills") { [ ] }
          
          allow(Global).to receive(:read_config).with("fs3skills", "allow_incapable_action_skills") { true }
          
          @char = double
        end
        
        it "should include Everyone skills" do
          allow(@char).to receive(:group).with("Position") { "Other" }
          allow(@char).to receive(:group).with("Faction") { "Other" }
          skills = { "A" => 2, "B" => 3 }
          expect(StartingSkills.get_skills_for_char(@char)).to eq skills
        end
        
        it "should include matching group skills" do
          allow(@char).to receive(:group).with("Position") { "Pilot" }
          allow(@char).to receive(:group).with("Faction") { "Other" }
          skills = { "A" => 2, "B" => 3, "C" => 4 }
          expect(StartingSkills.get_skills_for_char(@char)).to eq skills
        end

        it "should include the higher skill if multiple matches" do
          allow(@char).to receive(:group).with("Position") { "Pilot" }
          allow(@char).to receive(:group).with("Faction") { "Navy" }
          skills = { "A" => 2, "B" => 3, "C" => 4 }
          expect(StartingSkills.get_skills_for_char(@char)).to eq skills
        end
        
        it "should include default attributes" do
          allow(@char).to receive(:group).with("Position") { "Other" }
          allow(@char).to receive(:group).with("Faction") { "Other" }
          allow(Global).to receive(:read_config).with("fs3skills", "attributes") { [ { 'name' => 'Brawn' }, { 'name' => 'Presence' } ] }
          skills = { "A" => 2, "B" => 3, "Brawn" => 1, "Presence" => 1 }
          expect(StartingSkills.get_skills_for_char(@char)).to eq skills        
        end
        
        it "should include default action skills when incapable allowed" do
          allow(@char).to receive(:group).with("Position") { "Other" }
          allow(@char).to receive(:group).with("Faction") { "Other" }
          allow(Global).to receive(:read_config).with("fs3skills", "action_skills") { [ { 'name' => 'Melee' } ] }
          allow(Global).to receive(:read_config).with("fs3skills", "allow_incapable_action_skills") { true }
          skills = { "A" => 2, "B" => 3, "Melee" => 0 }
          expect(StartingSkills.get_skills_for_char(@char)).to eq skills        
        end

        it "should include default action skills when incapable not allowed" do
          allow(@char).to receive(:group).with("Position") { "Other" }
          allow(@char).to receive(:group).with("Faction") { "Other" }
          allow(Global).to receive(:read_config).with("fs3skills", "action_skills") { [ { 'name' => 'Melee' } ] }
          allow(Global).to receive(:read_config).with("fs3skills", "allow_incapable_action_skills") { false }
          skills = { "A" => 2, "B" => 3, "Melee" => 1 }
          expect(StartingSkills.get_skills_for_char(@char)).to eq skills        
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
          allow(Global).to receive(:read_config).with("fs3skills", "starting_skills") { starting_skills }
          @char = double
        end
        
        it "should include Everyone skills" do
          allow(@char).to receive(:group).with("Position") { "Other" }
          allow(@char).to receive(:group).with("Faction") { "Other" }
          specs = { "A" => [ "X", "Y" ], "B" => [ "Z" ] }
          expect(StartingSkills.get_specialties_for_char(@char)).to eq specs
        end
        
        it "should include matching group skills" do
          allow(@char).to receive(:group).with("Position") { "Pilot" }
          allow(@char).to receive(:group).with("Faction") { "Other" }
          specs = { "A" => [ "X", "Y", "U" ], "B" => [ "Z" ] }
          expect(StartingSkills.get_specialties_for_char(@char)).to eq specs
        end

        it "should include the higher skill if multiple matches" do
          allow(@char).to receive(:group).with("Position") { "Pilot" }
          allow(@char).to receive(:group).with("Faction") { "Navy" }
          specs = { "A" => [ "X", "Y", "U" ], "B" => [ "Z", "W" ] }
          expect(StartingSkills.get_specialties_for_char(@char)).to eq specs
        end
        
      end
    end
  end
end
