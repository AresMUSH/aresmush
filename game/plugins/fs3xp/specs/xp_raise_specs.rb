module AresMUSH
  module FS3XP
    describe XpRaiseCmd do
      include PluginSystemTest
      
      it_behaves_like "a plugin that fails if not logged in"
      
      it_behaves_like "a plugin that only accepts certain roots and switches"
      let(:wanted_cmds) { [ "xp/raise" ] }
      
      before do
        init_handler XpRaiseCmd
        Global.stub(:read_config).with("fs3xp", "skill_costs") { { 2 => 3} }
        Global.stub(:read_config).with("fs3xp", "max_rating_through_xp") { 5 }
        Global.stub(:read_config).with("fs3xp", "days_between_xp_raises") { 1 }
      end
      
      context "failures" do
        before do
          client.stub(:logged_in?) { true }
          char.stub(:is_approved) { true }
          char.stub(:last_xp_spend) { nil }
          char.stub(:xp) { 10 }
          FS3Skills.stub(:ability_rating).with(char, "Basketweaving") { 1 }
        end
        
        it "should fail if not approved" do
          char.stub(:is_approved) { false }
          client.should_receive(:emit_failure).with('fs3xp.not_approved')
          handler.on_command client, Command.new("xp/raise Basketweaving")
        end
        
        it "should fail if not enough xp" do
          char.stub(:xp) { 2 }
          client.should_receive(:emit_failure).with('fs3xp.not_enough_xp')
          handler.on_command client, Command.new("xp/raise Basketweaving")
        end
        
        it "should fail if too soon since last spend" do
          char.stub(:last_xp_spend) { Time.now }
          client.should_receive(:emit_failure).with('fs3xp.must_wait_to_spend')
          handler.on_command client, Command.new("xp/raise Basketweaving")
        end
        
        it "should fail if already at max rating" do
          FS3Skills.stub(:ability_rating).with(char, "Basketweaving") { 5 }
          client.should_receive(:emit_failure).with('fs3xp.cant_raise_further_with_xp')
          handler.on_command client, Command.new("xp/raise Basketweaving")
        end
      end
      
      context "success", :dbtest, :pluginsystemtest do
        before do
          setup_client_with_real_char
          client.stub(:logged_in?) { true }
          char.xp = 4
          char.is_approved = true
          FS3Skills.stub(:ability_rating).with(char, "Basketweaving") { 1 }
          FS3Skills.stub(:set_ability).with(client, char, "Basketweaving", 2) do
            char.fs3_action_skills = { "a" => "b" }
            true
          end
        end
        
        it "should set the new skill and save them" do
          handler.on_command client, Command.new("xp/raise Basketweaving")
          Character.find_by_name("TestDummy").fs3_action_skills["a"].should eq "b"
        end
        
        it "should adjust the character's xp" do
          handler.on_command client, Command.new("xp/raise Basketweaving")
          Character.find_by_name("TestDummy").xp.should eq 1
        end
        
        it "should update their last xp spend time" do
          fake_time =  Time.new(2013)
          Time.stub(:now) { fake_time }
          handler.on_command client, Command.new("xp/raise Basketweaving")
          Character.find_by_name("TestDummy").last_xp_spend.should eq fake_time
        end

        it "should not save if the skill set fails" do
          FS3Skills.stub(:set_ability).with(client, char, "Basketweaving", 2) do
            char.fs3_action_skills = { "a" => "b" }
            false
          end
          handler.on_command client, Command.new("xp/raise Basketweaving")
          Character.find_by_name("TestDummy").fs3_action_skills["a"].should be_nil
        end        
      end
    end
  end
end
