module AresMUSH
  module FS3XP
    
    describe XpLangCmd do
      include PluginSystemTest
      
      it_behaves_like "a plugin that fails if not logged in"
      
      it_behaves_like "a plugin that only accepts certain roots and switches"
      let(:wanted_cmds) { [ "xp/lang" ] }
      
      before do
        init_handler XpLangCmd
        Global.stub(:config) { { "fs3xp" => { "lang_cost" => 3 } } } 
      end
      
      context "failures" do
        before do
          client.stub(:logged_in?) { true }
          char.stub(:is_approved) { true }
        end
        
        it "should fail if not approved" do
          char.stub(:is_approved) { false }
          client.should_receive(:emit_failure).with('fs3xp.not_approved')
          handler.on_command client, Command.new("xp/lang Spanish")
        end
        
        it "should fail if missing the language" do
          client.should_receive(:emit_failure).with('dispatcher.invalid_syntax')
          handler.on_command client, Command.new("xp/lang ")
        end
        
        it "should fail if not enough xp" do
          char.stub(:xp) { 2 }
          client.should_receive(:emit_failure).with('fs3xp.not_enough_xp')
          handler.on_command client, Command.new("xp/lang Spanish")
        end
      end
      
      context "success", :dbtest do
        
          before do
            setup_client_with_real_char
            client.stub(:logged_in?) { true }
            char.is_approved = true
            char.xp = 4
            FS3Skills.stub(:add_language).with(client, char, "Spanish") do
              char.fs3_languages = ["Spanish"]
              true
            end
          end
          
          it "should give the char the language and save them" do
            handler.on_command client, Command.new("xp/lang Spanish")
            Character.find_by_name("TestDummy").fs3_languages.should eq ["Spanish"]
          end
          
          it "should adjust the char's xp" do
            handler.on_command client, Command.new("xp/lang Spanish")
            Character.find_by_name("TestDummy").xp.should eq 1
          end
          
          it "should update their last xp spend time" do
            fake_time =  Time.new(2013)
            Time.stub(:now) { fake_time }
            handler.on_command client, Command.new("xp/lang Spanish")
            Character.find_by_name("TestDummy").last_xp_spend.should eq fake_time
          end
          
          it "should not save if the skill set fails" do
            FS3Skills.stub(:add_language).with(client, char, "Spanish") do
              char.fs3_languages = ["Spanish"]
              false
            end
            handler.on_command client, Command.new("xp/lang Spanish")
            Character.find_by_name("TestDummy").fs3_languages.should eq []
          end
      end
    end
  end
end