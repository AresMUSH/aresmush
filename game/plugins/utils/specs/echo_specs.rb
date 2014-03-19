require_relative "../../plugin_test_loader"

module AresMUSH
  module Echo
    describe EchoCmd do
      include PluginCmdTestHelper
    
      before do
        init_handler(EchoCmd, "echo happy thoughts")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"

      describe :want_command do
        it "should want the echo command" do
          cmd.stub(:root_is?).with("echo") { true }
          handler.want_command?(client, cmd).should be_true
        end

        it "should not want another command" do
          cmd.stub(:root_is?).with("echo") { false }
          cmd.stub(:logged_in?) { true }          
          handler.want_command?(client, cmd).should be_false
        end        
      end

      describe :handle do
        it "should echo back to the client" do
          handler.crack!
          client.should_receive(:emit).with("happy thoughts")
          handler.handle
        end        
      end
    end
  end
end