module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        allow(Global).to receive(:read_config).with("fs3skills", "max_skill_rating") { 7 }
        allow(Global).to receive(:read_config).with("fs3skills", "max_attr_rating") { 4 }
        allow(FS3Skills).to receive(:attr_names) { [ "Brawn", "Mind" ] }
        allow(FS3Skills).to receive(:action_skill_names) { [ "Firearms", "Demolitions" ] }
        allow(FS3Skills).to receive(:advantage_names) { [ "Rank" ] }
        allow(FS3Skills).to receive(:language_names) { [ "English", "Spanish" ] }
        allow(Global).to receive(:read_config).with("fs3skills", "allow_unskilled_action_skills") { false }
        stub_translate_for_testing
      end
      
      describe :check_ability_name do
        it "should not allow funky chars" do
          # Because it will mess up the +/- modifier parsing
          expect(FS3Skills.check_ability_name("X+Y")).to eq "fs3skills.no_special_characters"
          expect(FS3Skills.check_ability_name("X-Y")).to eq "fs3skills.no_special_characters"
          expect(FS3Skills.check_ability_name("X=Y")).to eq "fs3skills.no_special_characters"
          expect(FS3Skills.check_ability_name("X,Y")).to eq "fs3skills.no_special_characters"
          
          # For aesthetic reasons
          expect(FS3Skills.check_ability_name("X:.[]|Y")).to eq "fs3skills.no_special_characters"
          
          # Because folks on older clients can't see them properly.
          expect(FS3Skills.check_ability_name("XñY")).to eq "fs3skills.no_special_characters"
        end
        
        it "should allow spaces and underlines" do
          expect(FS3Skills.check_ability_name("X Y")).to be_nil
          expect(FS3Skills.check_ability_name("X_Y")).to be_nil
        end
      end
      
      describe :check_rating do
        it "should error if below min ratings" do
          expect(FS3Skills.check_rating("Brawn", 0)).to eq "fs3skills.min_rating_is"
          expect(FS3Skills.check_rating("Firearms", -1)).to eq "fs3skills.min_rating_is"
          expect(FS3Skills.check_rating("English", -1)).to eq "fs3skills.min_rating_is"
          expect(FS3Skills.check_rating("Basketweaving", -1)).to eq "fs3skills.min_rating_is"
        end
        
        it "should allow unskilled for min rating if configured" do
          allow(Global).to receive(:read_config).with("fs3skills", "allow_unskilled_action_skills") { true }
          expect(FS3Skills.check_rating("Brawn", 0)).to eq "fs3skills.min_rating_is"
        end
        
        it "should allow min ratings" do
          expect(FS3Skills.check_rating("Brawn", 1)).to be_nil
          expect(FS3Skills.check_rating("Firearms", 1)).to be_nil
          expect(FS3Skills.check_rating("English", 0)).to be_nil
          expect(FS3Skills.check_rating("Basketweaving", 0)).to be_nil
        end

        it "should allow max ratings" do
          expect(FS3Skills.check_rating("Brawn", 4)).to be_nil
          expect(FS3Skills.check_rating("Firearms", 7)).to be_nil
          expect(FS3Skills.check_rating("English", 3)).to be_nil
          expect(FS3Skills.check_rating("Basketweaving", 3)).to be_nil
        end
        
        it "should error if above max ratings" do
          expect(FS3Skills.check_rating("Brawn", 5)).to eq "fs3skills.max_rating_is"
          expect(FS3Skills.check_rating("Firearms", 8)).to eq "fs3skills.max_rating_is"
          expect(FS3Skills.check_rating("English", 4)).to eq "fs3skills.max_rating_is"
          expect(FS3Skills.check_rating("Basketweaving", 4)).to eq "fs3skills.max_rating_is"
        end
        
        it "should allow max action skill rating to be configurable" do
          allow(Global).to receive(:read_config).with("fs3skills", "max_skill_rating") { 5 }
          expect(FS3Skills.check_rating("Firearms", 5)).to be_nil
          expect(FS3Skills.check_rating("Firearms", 6)).to eq "fs3skills.max_rating_is"
        end
      end
      
      describe :set_ability do 
        before do
          allow(FS3Skills).to receive(:check_rating) { nil }
          allow(FS3Skills).to receive(:check_ability_name) { nil }
          
          @client = double
          @char = double
        end
          
        it "should error if abiliy name invalid" do 
          allow(FS3Skills).to receive(:check_ability_name) { "an error" }
          expect(@client).to receive(:emit_failure).with("an error")
          FS3Skills.set_ability(@client, @char, "Firearms", 4)
        end
        
        
        context "success" do
          before do
            @ability = double
            allow(@char).to receive(:id) { 1 }
            allow(FS3Skills).to receive(:find_ability).with(@char, "Firearms") { @ability }
            allow(@ability).to receive(:update)
            allow(@client).to receive(:emit_success)
            allow(@char).to receive(:name) { "Bob" }
            allow(@ability).to receive(:rating_name) { "X" }
          end
        
          it "should emit one message for changing your own ability" do
            allow(@client).to receive(:char_id) { 1 }
            expect(@client).to receive(:emit_success).with("fs3skills.action_set")
            FS3Skills.set_ability(@client, @char, "Firearms", 4)
          end
        
          it "should emit a different message for changing someone else's ability" do
            allow(@client).to receive(:char_id) { 2 }
            expect(@client).to receive(:emit_success).with("fs3skills.admin_ability_set")
            FS3Skills.set_ability(@client, @char, "Firearms", 4)
          end
          
          it "should update an existing ability" do
            allow(@client).to receive(:char_id) { 2 }
            expect(@ability).to receive(:update).with(rating: 4)
            FS3Skills.set_ability(@client, @char, "Firearms", 4)
          end

          it "should create a new ability" do
            allow(@client).to receive(:char_id) { 2 }
            allow(FS3Skills).to receive(:find_ability).with(@char, "Firearms") { nil }
            expect(FS3ActionSkill).to receive(:create).with(character: @char, name: "Firearms", rating: 4) { @ability }
            FS3Skills.set_ability(@client, @char, "Firearms", 4)
          end
        end
      end
    end
  end
end
        
