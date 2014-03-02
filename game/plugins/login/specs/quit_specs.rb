require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe QuitCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(QuitCmd, "quit")
        SpecHelpers.stub_translate_for_testing        
      end

      it_behaves_like "a plugin that doesn't allow switches"

      describe :want_command do
        it "should want the quit command" do
          cmd.stub(:root_is?).with("quit") { true }
          handler.want_command?(client, cmd).should be_true
        end

        it "should not want another command" do
          cmd.stub(:root_is?).with("quit") { false }
          handler.want_command?(client, cmd).should be_false
        end        
      end

      describe :handle do
        before do
          handler.crack!
        end
        
        it "should disconnect the client" do
          client.should_receive(:disconnect)
          client.stub(:emit_ooc)
          handler.handle
        end
        
        it "should send the bye text" do
          client.stub(:disconnect)
          client.should_receive(:emit_ooc).with("login.goodbye")
          handler.handle
        end
      end
    end
  end
end