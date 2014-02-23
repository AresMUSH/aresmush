require_relative "../../plugin_test_loader"

module AresMUSH
  module Echo
    describe EchoCmd do
      include CommandTestHelper
    
      before do
        init_handler(EchoCmd, "echo happy thoughts")
        SpecHelpers.stub_translate_for_testing        
      end

      describe :want_command do
        it "should want the echo command" do
          cmd.stub(:root_is?).with("echo") { true }
          cmd.stub(:root_is?).with("think") { false }
          handler.want_command?(client, cmd).should be_true
        end

        it "should want the think command" do
          cmd.stub(:root_is?).with("think") { true }
          cmd.stub(:root_is?).with("echo") { false }
          handler.want_command?(client, cmd).should be_true
        end

        it "should not want another command" do
          cmd.stub(:root_is?).with("echo") { false }
          cmd.stub(:root_is?).with("think") { false }
          cmd.stub(:logged_in?) { true }          
          handler.want_command?(client, cmd).should be_false
        end        
      end

      describe :handle do
        it "should echo back to the client" do
          client.should_receive(:emit).with("happy thoughts")
          handler.handle
        end        
      end
    end
  end
end