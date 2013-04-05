require_relative "../../plugin_test_loader"

module AresMUSH
  module Think
    describe Think do
      before do
        @cmd = double(Command)
        @think = Think.new(nil)
      end

      describe :want_command do
        it "should want the think command" do
          @cmd.stub(:root_is?).with("think") { true }
          @think.want_command?(@cmd).should be_true
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("think") { false }
          @think.want_command?(@cmd).should be_false
        end        
      end

      describe :want_anon_command do
        it "should not want any commands" do
          @think.want_anon_command?(@cmd).should be_false
        end
      end

      describe :on_command do
        before do
          @client = double(Client)
          @client.stub(:emit)
          @enactor = mock
          @client.stub(:char) { @enactor }
        end
        
        it "should echo back to the client" do
          Formatter.stub(:perform_subs) { "happy thoughts" }
          @client.should_receive(:emit).with("happy thoughts")
          cmd = Command.new(@client, "think happy thoughts")
          @think.on_command(@client, cmd)
        end
        
        it "should perform subs on the echoed message" do
          Formatter.should_receive(:perform_subs).with("happy thoughts") { "whee" }
          @client.should_receive(:emit).with("whee")
          cmd = Command.new(@client, "think happy thoughts")
          @think.on_command(@client, cmd)
        end
        
      end
    end
  end
end