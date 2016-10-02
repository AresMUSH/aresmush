module AresMUSH
  module FS3Skills
    describe FS3Skills do
      
      before do
        Global.stub(:read_config).with("fs3skills", "aptitudes") { [ { "name" => "Mind" }, {"name" => "Body" } ] }
        Global.stub(:read_config).with("fs3skills", "action_skills") { [ { "name" => "Firearms", "linked_attr" => "Reaction" }, { "name" => "First Aid" } ] }
        Global.stub(:read_config).with("fs3skills", "default_linked_attr") { "Mind" }
        Global.stub(:read_config).with("fs3skills", "advantages") { [{ "name" => "Wealth" }] }

        SpecHelpers.stub_translate_for_testing   
      end
      
      describe :set_ability do
        before do
          @client = double
          @char = Character.new
          @char.stub(:save)
          @client.stub(:emit_success)
          @char.stub(:client) { @client }
        end
        
        context "aptitudes" do
          it "should set a new ability" do
            FS3Skills.set_ability(@client, @char, "Mind", 2)
            @char.fs3_aptitudes["Mind"].should eq 2
          end
        
          it "should update an ability" do
            FS3Skills.set_ability(@client, @char, "Mind", 2)
            FS3Skills.set_ability(@client, @char, "Mind", 3)
            @char.fs3_aptitudes["Mind"].should eq 3
          end
        
          it "should fail if rating too high" do
            @client.should_receive(:emit_failure).with('fs3skills.max_rating_is')
            FS3Skills.set_ability(@client, @char, "Mind", 6)
          end
          
          it "should fail if rating too low" do
            @client.should_receive(:emit_failure).with('fs3skills.min_rating_is')
            FS3Skills.set_ability(@client, @char, "Mind", -1)
          end
        end
      
        context "action skills" do
          it "should set a new ability" do
            FS3Skills.set_ability(@client, @char, "Firearms", 2)
            @char.fs3_action_skills["Firearms"].should eq 2
          end
        
          it "should update an ability" do
            FS3Skills.set_ability(@client, @char, "Firearms", 2)
            FS3Skills.set_ability(@client, @char, "Firearms", 3)
            @char.fs3_action_skills["Firearms"].should eq 3
          end
        
          it "should clear an ability" do
            FS3Skills.set_ability(@client, @char, "Firearms", 2)
            FS3Skills.set_ability(@client, @char, "Firearms", 0)
            @char.fs3_action_skills["Firearms"].should be_nil            
          end
        
          it "should fail if rating too high" do
            @client.should_receive(:emit_failure).with('fs3skills.max_rating_is')
            FS3Skills.set_ability(@client, @char, "Firearms", 13)
          end
          
          it "should fail if rating too low" do
            @client.should_receive(:emit_failure).with('fs3skills.min_rating_is')
            FS3Skills.set_ability(@client, @char, "Firearms", -1)
          end
                
          it "should fail if + in skill name" do
            @client.should_receive(:emit_failure).with('fs3skills.no_special_characters')
            FS3Skills.set_ability(@client, @char, "Basket+Weaving", 2)
          end
        
          it "should fail if - in skill name" do
            @client.should_receive(:emit_failure).with('fs3skills.no_special_characters')
            FS3Skills.set_ability(@client, @char, "Basket-Weaving", 2)
          end
        
          it "should fail if / in skill name" do
            @client.should_receive(:emit_failure).with('fs3skills.no_special_characters')
            FS3Skills.set_ability(@client, @char, "Basket/Weaving", 2)
          end
        
          it "should allow spaces in skill name" do
            FS3Skills.set_ability(@client, @char, "First Aid", 2)
            @char.fs3_action_skills["First Aid"].should eq 2
          end
        end
        
        context "advantages" do
          it "should set a new ability" do
            FS3Skills.set_ability(@client, @char, "Wealth", 2)
            @char.fs3_advantages["Wealth"].should eq 2
          end
        
          it "should update an ability" do
            FS3Skills.set_ability(@client, @char, "Wealth", 2)
            FS3Skills.set_ability(@client, @char, "Wealth", 3)
            @char.fs3_advantages["Wealth"].should eq 3
          end
        
          it "should fail if rating too high" do
            @client.should_receive(:emit_failure).with('fs3skills.max_rating_is')
            FS3Skills.set_ability(@client, @char, "Wealth", 6)
          end
          
          it "should fail if rating too low" do
            @client.should_receive(:emit_failure).with('fs3skills.min_rating_is')
            FS3Skills.set_ability(@client, @char, "Wealth", -1)
          end
        end
      end
      
      describe :parse_and_roll do
        before do
          @client = double
          @char = double
        end
        
        it "should emit failure and return nil if it can't parse the roll" do
          FS3Skills.stub(:parse_roll_params) { nil }
          @client.should_receive(:emit_failure).with 'fs3skills.unknown_roll_params'
          FS3Skills.parse_and_roll(@client, @char, "x").should be_nil
        end
        
        it "should return a die result for a plain number" do
          FS3Skills.stub(:roll_dice).with(2) { [1, 2] }
          FS3Skills.parse_and_roll(@client, @char, "2").should eq [1, 2]
        end
        
        it "should parse results and roll the ability for any other string" do
          FS3Skills.stub(:parse_roll_params) { "x" }
          FS3Skills.stub(:roll_ability).with(@client, @char, "x") { [1, 2, 3]}
          FS3Skills.parse_and_roll(@client, @char, "abc").should eq [1, 2, 3]
        end
      end
      
      describe :emit_results do
        before do
          @main_client = double
          @main_char = double
          SpecHelpers.setup_mock_client(@main_client, @main_char)
          
          @admin_client = double
          @admin_char = double
          SpecHelpers.setup_mock_client(@admin_client, @admin_char)
          
          @nonadmin_client = double
          @nonadmin_char = double 
          SpecHelpers.setup_mock_client(@nonadmin_client, @nonadmin_char)
          
          FS3Skills.stub(:receives_roll_results?).with(@main_char) { true }
          FS3Skills.stub(:receives_roll_results?).with(@admin_char) { true }
          FS3Skills.stub(:receives_roll_results?).with(@nonadmin_char) { false }
          
          @room = double
          @main_char.stub(:room) { @room }
          @admin_char.stub(:room) { @room }
          @nonadmin_char.stub(:room) { @room }
          
          client_monitor = double
          Global.stub(:client_monitor) { client_monitor }
          client_monitor.stub(:logged_in) { 
            {
              @admin_client => @admin_char,
              @main_client => @main_char,
              @nonadmin_client => @nonadmin_char
              } }
        end
        
        context "private roll" do
          it "should emit to the client and admin" do
            @main_client.should_receive(:emit).with("test")
            @admin_client.should_receive(:emit).with("test")
            FS3Skills.emit_results("test", @main_client, @room, true)
          end
          
          it "should not emit to the room or non-admin" do
            @room.should_not_receive(:emit).with("test")
            @nonadmin_client.should_not_receive(:emit).with("test")
            @main_client.stub(:emit)
            @admin_client.stub(:emit)
            FS3Skills.emit_results("test", @main_client, @room, true)
          end
        end
        
        context "public roll" do
          it "should emit to the room and an admin not in the room" do
            @admin_char.stub(:room) { nil }
            @admin_client.should_receive(:emit).with("test")
            @room.should_receive(:emit).with("test")
            FS3Skills.emit_results("test", @main_client, @room, false)
          end
          
          it "should not emit to the client, non-admin, or admin in the room" do
            @admin_client.should_not_receive(:emit).with("test")
            @nonadmin_client.should_not_receive(:emit).with("test")
            @main_client.should_not_receive(:emit).with("test")
            @room.stub(:emit)
            FS3Skills.emit_results("test", @main_client, @room, false)
          end
        end
      end
      
      
      describe :can_parse_roll_params do
        it "should handle aptitude by itself" do
          params = FS3Skills.parse_roll_params("A")
          check_params(params, "A", 0, nil)
        end
        
        it "should handle abiliity and positive modifier" do
          params = FS3Skills.parse_roll_params("A+22")
          check_params(params, "A", 22, nil)
        end

        it "should handle abiliity and positive modifier" do
          params = FS3Skills.parse_roll_params("A+22")
          check_params(params, "A", 22, nil)
        end

        it "should handle abiliity and negative modifier" do
          params = FS3Skills.parse_roll_params("A-3")
          check_params(params, "A", -3, nil)
        end
        
        it "should handle ability with space" do
          params = FS3Skills.parse_roll_params("A B")
          check_params(params, "A B", 0, nil)
        end
        
        it "should handle ability with modifier and space" do
          params = FS3Skills.parse_roll_params("A B + 3")
          check_params(params, "A B", 3, nil)
        end

        it "should handle ability with modifier and ruling attr and space" do
          params = FS3Skills.parse_roll_params("A B + C D + 3")
          check_params(params, "A B", 3, "C D")
        end
        
        it "should handle ability and ruling attr" do
          params = FS3Skills.parse_roll_params("A+B")
          check_params(params, "A", 0, "B")
        end

        it "should handle ability and ruling attr and modifier" do
          params = FS3Skills.parse_roll_params("A+B-2")
          check_params(params, "A", -2, "B")
        end
        
        it "should handle bad string with negative ruling attr" do
          params = FS3Skills.parse_roll_params("A-B+2")
          params.should be_nil
        end

        it "should handle bad string with a non-digit modifier" do
          params = FS3Skills.parse_roll_params("A+B+C")
          params.should be_nil
        end
        
        it "should handle bad string with too many params" do
          params = FS3Skills.parse_roll_params("A+B+2+D")
          params.should be_nil
        end
      end
      
      def check_params(params, ability, modifier, linked_attr)
        params.ability.should eq ability
        params.modifier.should eq modifier
        params.linked_attr.should eq linked_attr
      end
      
      describe :dice_to_roll_for_ability do
        before do
          @char = double
          @char.stub(:name) { "Nemo" }
                  
          FS3Skills.stub(:get_ability_type).with(@char, "Firearms") { :action }
          FS3Skills.stub(:ability_rating).with(@char, "Firearms") { 1 }
          FS3Skills.stub(:ability_rating).with(@char, "Mind") { 1 }
          FS3Skills.stub(:ability_rating).with(@char, "Reaction") { 3 }
          FS3Skills.stub(:ability_rating).with(@char, "Untrained") { 0 }
          FS3Skills.stub(:ability_rating).with(@char, "Basketweaving") { 3 }
          FS3Skills.stub(:get_linked_attr).with(@char, "Firearms") { "Reaction" }
          FS3Skills.stub(:get_linked_attr).with(@char, "Basketweaving") { "Reaction" }
        end
      
        it "should roll ability alone" do
          roll_params = RollParams.new("Firearms")
          # Rolls Firearms + Reaction 
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 5
        end
      
        it "should roll ability + a different ruling attr" do
          roll_params = RollParams.new("Firearms", 0, "Mind")
          # Rolls Firearms + Mind
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 3
        end
      
        it "should roll ability + modifier" do
          roll_params = RollParams.new("Firearms", 1)
          # Rolls Firearms + Reaction + 1
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 6
        end
      
        it "should roll ability - modifier" do
          roll_params = RollParams.new("Firearms", -1)
          # Rolls Firearms + Reaction - 1 
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 4
        end
      
        it "should roll ability + ruling attr + modifier" do
          roll_params = RollParams.new("Firearms", 3, "Mind")
          # Rolls Firearms + Mind + 3 
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 6
        end
        
        it "should roll 1 for poor aptitude" do
          roll_params = RollParams.new("Mind")
          FS3Skills.stub(:ability_rating).with(@char, "Mind") { 1 }
          FS3Skills.stub(:get_ability_type).with(@char, "Mind") { :aptitude }
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 1
        end
        it "should roll 2 for avg aptitude" do
          roll_params = RollParams.new("Mind")
          FS3Skills.stub(:ability_rating).with(@char, "Mind") { 2 }
          FS3Skills.stub(:get_ability_type).with(@char, "Mind") { :aptitude }
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 2
        end
        it "should roll 3 for good aptitude" do
          roll_params = RollParams.new("Mind")
          FS3Skills.stub(:ability_rating).with(@char, "Mind") { 3 }
          FS3Skills.stub(:get_ability_type).with(@char, "Mind") { :aptitude }
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 3
        end
        it "should roll 4 for great aptitude" do
          roll_params = RollParams.new("Mind")
          FS3Skills.stub(:ability_rating).with(@char, "Mind") { 4 }
          FS3Skills.stub(:get_ability_type).with(@char, "Mind") { :aptitude }
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 4
        end
        
        it "should not count aptitude mod for nonexistant" do
          roll_params = RollParams.new("Untrained")
          FS3Skills.stub(:get_ability_type).with(@char, "Untrained") { :nonexistant }
          # Rolls Unskilled + no modifier --> 0 dice
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 0
        end
        
        it "should count aptitude mod for an interest" do
          roll_params = RollParams.new("Basketweaving")
          FS3Skills.stub(:get_ability_type).with(@char, "Basketweaving") { :interest }
          # Basketweaving stubbed to return rating 3 + Reaction
          FS3Skills.dice_to_roll_for_ability(@char, roll_params).should eq 9
        end
      end
    end
  end
end