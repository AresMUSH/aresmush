module AresMUSH
  module FS3Skills
    describe FS3Skills do
      include MockClient
      
      before do
        Global.stub(:config) {
          {
            "fs3skills" => {
              "attributes" => [ { "name" => "Mind" }, {"name" => "Body" } ],
              "action_skills" => [ { "name" => "Firearms", "ruling_attr" => "Reaction" } ],
              "default_ruling_attr" => "Mind"
            }
          }
        }
        
        SpecHelpers.stub_translate_for_testing   
      end
      
      describe :set_ability do
        before do
          @client = double
          @char = Character.new
          @char.stub(:save)
          @client.stub(:emit_success)
          @client.stub(:char) { @char }
        end
        
        context "attributes" do
          it "should set a new ability" do
            FS3Skills.set_ability(@client, @char, "Mind", 2)
            @char.fs3_attributes["Mind"]["rating"].should eq 2
          end
        
          it "should update an ability" do
            FS3Skills.set_ability(@client, @char, "Mind", 2)
            FS3Skills.set_ability(@client, @char, "Mind", 3)
            @char.fs3_attributes["Mind"]["rating"].should eq 3
          end
        
          it "should fail if rating too high" do
            @client.should_receive(:emit_failure).with('fs3skills.max_rating_is')
            FS3Skills.set_ability(@client, @char, "Mind", 5)
          end
          
          it "should fail if rating too low" do
            @client.should_receive(:emit_failure).with('fs3skills.min_rating_is')
            FS3Skills.set_ability(@client, @char, "Mind", 0)
          end
        end
      
        context "action skills" do
          it "should set a new ability" do
            FS3Skills.set_ability(@client, @char, "Firearms", 2)
            @char.fs3_action_skills["Firearms"]["rating"].should eq 2
          end
        
          it "should update an ability" do
            FS3Skills.set_ability(@client, @char, "Firearms", 2)
            FS3Skills.set_ability(@client, @char, "Firearms", 3)
            @char.fs3_action_skills["Firearms"]["rating"].should eq 3
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
        end
      
        context "bg skills" do
          it "should set a new ability" do
            FS3Skills.set_ability(@client, @char, "Basketweaving", 2)
            @char.fs3_background_skills["Basketweaving"]["rating"].should eq 2
          end
        
          it "should update an ability" do
            FS3Skills.set_ability(@client, @char, "Basketweaving", 2)
            FS3Skills.set_ability(@client, @char, "Basketweaving", 3)
            @char.fs3_background_skills["Basketweaving"]["rating"].should eq 3
          end
        
          it "should clear an ability" do
            FS3Skills.set_ability(@client, @char, "Basketweaving", 2)
            FS3Skills.set_ability(@client, @char, "Basketweaving", 0)
            @char.fs3_background_skills["Basketweaving"].should be_nil            
          end
        
          it "should fail if rating too high" do
            @client.should_receive(:emit_failure).with('fs3skills.max_rating_is')
            FS3Skills.set_ability(@client, @char, "Basketweaving", 13)
          end
          
          it "should fail if rating too low" do
            @client.should_receive(:emit_failure).with('fs3skills.min_rating_is')
            FS3Skills.set_ability(@client, @char, "Basketweaving", -1)
          end
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
          FS3Skills.set_ability(@client, @char, "Basket Weaving", 2)
          @char.fs3_background_skills["Basket Weaving"]["rating"].should eq 2
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
          @client = build_mock_client
          @admin = build_mock_client
          @nonadmin = build_mock_client
          
          FS3Skills.stub(:receives_roll_results?).with(@client[:char]) { true }
          FS3Skills.stub(:receives_roll_results?).with(@admin[:char]) { true }
          FS3Skills.stub(:receives_roll_results?).with(@nonadmin[:char]) { false }
          
          @room = double
          @client[:client].stub(:room) { @room }
          @admin[:client].stub(:room) { @room }
          @nonadmin[:client].stub(:room) { @room }
          
          client_monitor = double
          Global.stub(:client_monitor) { client_monitor }
          client_monitor.stub(:logged_in_clients) { [@client[:client], @admin[:client], @nonadmin[:client] ]}
        end
        
        context "private roll" do
          it "should emit to the client and admin" do
            @client[:client].should_receive(:emit).with("test")
            @admin[:client].should_receive(:emit).with("test")
            FS3Skills.emit_results("test", @client[:client], @room, true)
          end
          
          it "should not emit to the room or non-admin" do
            @room.should_not_receive(:emit).with("test")
            @nonadmin[:client].should_not_receive(:emit).with("test")
            @client[:client].stub(:emit)
            @admin[:client].stub(:emit)
            FS3Skills.emit_results("test", @client[:client], @room, true)
          end
        end
        
        context "public roll" do
          it "should emit to the room and an admin not in the room" do
            @admin[:client].stub(:room) { nil }
            @admin[:client].should_receive(:emit).with("test")
            @room.should_receive(:emit).with("test")
            FS3Skills.emit_results("test", @client[:client], @room, false)
          end
          
          it "should not emit to the client, non-admin, or admin in the room" do
            @admin[:client].should_not_receive(:emit).with("test")
            @nonadmin[:client].should_not_receive(:emit).with("test")
            @client[:client].should_not_receive(:emit).with("test")
            @room.stub(:emit)
            FS3Skills.emit_results("test", @client[:client], @room, false)
          end
        end
      end
      
      
      describe :can_parse_roll_params do
        it "should handle attribute by itself" do
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
      
      def check_params(params, ability, modifier, ruling_attr)
        params.ability.should eq ability
        params.modifier.should eq modifier
        params.ruling_attr.should eq ruling_attr
      end
    end
  end
end