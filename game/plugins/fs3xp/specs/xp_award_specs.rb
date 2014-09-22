module AresMUSH
  module FS3XP
    
    describe XpAwardCmd do
      include PluginSystemTest
      
      it_behaves_like "a plugin that fails if not logged in"
      
      it_behaves_like "a plugin that only accepts certain roots and switches"
      let(:wanted_cmds) { [ "xp/award" ] }
      
      before do
        init_handler XpAwardCmd
        FS3XP.stub(:can_manage_xp?).with(char) { true }
      end
      
      context "failure" do
        before do
          client.stub(:logged_in?) { true }
        end
        
        it "should fail if not allowed" do
          FS3XP.stub(:can_manage_xp?).with(char) { false }
          client.should_receive(:emit_failure).with('dispatcher.not_allowed')
          handler.on_command client, Command.new("xp/award Bob=1")
        end
        
        it "should fail if missing one arg" do
          client.should_receive(:emit_failure).with('dispatcher.invalid_syntax')
          handler.on_command client, Command.new("xp/award Bob")
        end

        it "should fail if missing all args" do
          client.should_receive(:emit_failure).with('dispatcher.invalid_syntax')
          handler.on_command client, Command.new("xp/award ")
        end
        
        it "should fail if xp is not a number" do
          client.should_receive(:emit_failure).with('fs3xp.invalid_xp_award')
          handler.on_command client, Command.new("xp/award Bob=x")
        end
        
        it "should fail if char not found" do
          Character.stub(:find_all_by_name_or_id).with("Bob") { nil }
          client.should_receive(:emit_failure).with('db.object_not_found')
          handler.on_command client, Command.new("xp/award Bob=1")
        end
      end
        
      context "success", :dbtest do
        before do
          client.stub(:logged_in?) { true }
          @target = Character.new(:name => "Bob", :xp => 4)
          Character.stub(:find_all_by_name_or_id).with("Bob") { [ @target ] }
          AresMUSH::Locale.stub(:translate).with("fs3xp.xp_awarded", { :name => "Bob", :xp => "3" }) { "xp awarded" }        
          client.should_receive(:emit_success).with("xp awarded")
        end
          
        it "should adjust the character's xp and save them" do
          handler.on_command client, Command.new("xp/award Bob=3")
          Character.find_by_name("Bob").xp.should eq 7
        end
      end
    end
  end
end