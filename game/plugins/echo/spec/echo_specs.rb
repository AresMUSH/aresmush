require_relative "../../plugin_test_loader"

module AresMUSH
  module Echo
    describe Echo do
      before do
        @cmd = double(Command)
        @echo = Echo.new
      end

      describe :want_command do
        it "should want the echo command if logged in" do
          @cmd.stub(:root_is?).with("echo") { true }
          @cmd.stub(:logged_in?) { true }
          @echo.want_command?(@cmd).should be_true
        end

        it "should not want the echo command if not logged in" do
          @cmd.stub(:root_is?).with("echo") { true }
          @cmd.stub(:logged_in?) { false }
          @echo.want_command?(@cmd).should be_false
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("echo") { false }
          @cmd.stub(:logged_in?) { true }          
          @echo.want_command?(@cmd).should be_false
        end        
      end

      describe :on_command do
        before do
          @client = double(Client)
          @client.stub(:emit)
          @enactor = double
          @client.stub(:char) { @enactor }
        end
        
        it "should echo back to the client" do
          @client.should_receive(:emit).with("happy thoughts")
          cmd = Command.new(@client, "echo happy thoughts")
          @echo.on_command(@client, cmd)
        end        
      end
    end
  end
end