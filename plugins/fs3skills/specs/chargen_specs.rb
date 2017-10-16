module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        Global.stub(:read_config).with("fs3skills", "max_skill_rating") { 7 }
        FS3Skills.stub(:attr_names) { [ "Brawn", "Mind" ] }
        FS3Skills.stub(:action_skill_names) { [ "Firearms", "Demolitions" ] }
        FS3Skills.stub(:language_names) { [ "English", "Spanish" ] }
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :check_ability_name do
        it "should not allow funky chars" do
          # Because it will mess up the +/- modifier parsing
          FS3Skills.check_ability_name("X+Y").should eq "fs3skills.no_special_characters"
          FS3Skills.check_ability_name("X-Y").should eq "fs3skills.no_special_characters"
          FS3Skills.check_ability_name("X=Y").should eq "fs3skills.no_special_characters"
          FS3Skills.check_ability_name("X,Y").should eq "fs3skills.no_special_characters"
          
          # For aesthetic reasons
          FS3Skills.check_ability_name("X:.[]|Y").should eq "fs3skills.no_special_characters"
        end
        
        it "should allow spaces and underlines" do
          FS3Skills.check_ability_name("X Y").should be_nil
          FS3Skills.check_ability_name("X_Y").should be_nil
        end
      end
      
      describe :check_rating do
        it "should error if below min ratings" do
          FS3Skills.check_rating("Brawn", 0).should eq "fs3skills.min_rating_is"
          FS3Skills.check_rating("Firearms", -1).should eq "fs3skills.min_rating_is"
          FS3Skills.check_rating("English", -1).should eq "fs3skills.min_rating_is"
          FS3Skills.check_rating("Basketweaving", -1).should eq "fs3skills.min_rating_is"
        end
        
        it "should allow min ratings" do
          FS3Skills.check_rating("Brawn", 1).should be_nil
          FS3Skills.check_rating("Firearms", 1).should be_nil
          FS3Skills.check_rating("English", 0).should be_nil
          FS3Skills.check_rating("Basketweaving", 0).should be_nil
        end

        it "should allow max ratings" do
          FS3Skills.check_rating("Brawn", 5).should be_nil
          FS3Skills.check_rating("Firearms", 7).should be_nil
          FS3Skills.check_rating("English", 3).should be_nil
          FS3Skills.check_rating("Basketweaving", 3).should be_nil
        end
        
        it "should error if above max ratings" do
          FS3Skills.check_rating("Brawn", 6).should eq "fs3skills.max_rating_is"
          FS3Skills.check_rating("Firearms", 8).should eq "fs3skills.max_rating_is"
          FS3Skills.check_rating("English", 4).should eq "fs3skills.max_rating_is"
          FS3Skills.check_rating("Basketweaving", 4).should eq "fs3skills.max_rating_is"
        end
        
        it "should allow max action skill rating to be configurable" do
          Global.stub(:read_config).with("fs3skills", "max_skill_rating") { 5 }
          FS3Skills.check_rating("Firearms", 5).should be_nil
          FS3Skills.check_rating("Firearms", 6).should eq "fs3skills.max_rating_is"
        end
      end
      
      describe :set_ability do 
        before do
          FS3Skills.stub(:check_rating) { nil }
          FS3Skills.stub(:check_ability_name) { nil }
          
          @client = double
          @char = double
        end
          
        it "should error if abiliy name invalid" do 
          FS3Skills.stub(:check_ability_name) { "an error" }
          @client.should_receive(:emit_failure).with("an error")
          FS3Skills.set_ability(@client, @char, "Firearms", 4)
        end
        
        it "should error if abiliy rating invalid" do 
          FS3Skills.stub(:check_rating) { "an error" }
          @client.should_receive(:emit_failure).with("an error")
          FS3Skills.set_ability(@client, @char, "Firearms", 4)
        end
        
        context "success" do
          before do
            @ability = double
            @char.stub(:id) { 1 }
            FS3Skills.stub(:find_ability).with(@char, "Firearms") { @ability }
            @ability.stub(:update)
            @client.stub(:emit_success)
            @char.stub(:name) { "Bob" }
            @ability.stub(:rating_name) { "X" }
          end
        
          it "should emit one message for changing your own ability" do
            @client.stub(:char_id) { 1 }
            @client.should_receive(:emit_success).with("fs3skills.action_set")
            FS3Skills.set_ability(@client, @char, "Firearms", 4)
          end
        
          it "should emit a different message for changing someone else's ability" do
            @client.stub(:char_id) { 2 }
            @client.should_receive(:emit_success).with("fs3skills.admin_ability_set")
            FS3Skills.set_ability(@client, @char, "Firearms", 4)
          end
          
          it "should update an existing ability" do
            @client.stub(:char_id) { 2 }
            @ability.should_receive(:update).with(rating: 4)
            FS3Skills.set_ability(@client, @char, "Firearms", 4)
          end

          it "should create a new ability" do
            @client.stub(:char_id) { 2 }
            FS3Skills.stub(:find_ability).with(@char, "Firearms") { nil }
            FS3ActionSkill.should_receive(:create).with(character: @char, name: "Firearms", rating: 4) { @ability }
            FS3Skills.set_ability(@client, @char, "Firearms", 4)
          end
        end
      end
    end
  end
end
        