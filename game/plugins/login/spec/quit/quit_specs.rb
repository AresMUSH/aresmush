require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe Quit do

      before do
        @cmd = double(Command)
        @client = double(Client)
        @quit = Quit.new
        SpecHelpers.stub_translate_for_testing
      end

      describe :want_command do
        it "should want the quit command" do
          @cmd.stub(:root_is?).with("quit") { true }
          @quit.want_command?(@cmd).should be_true
        end

        it "should want the quit command" do
          @cmd.stub(:root_is?).with("quit") { true }
          @quit.want_command?(@cmd).should be_true
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("quit") { false }
          @quit.want_command?(@cmd).should be_false
        end        
      end

      describe :on_command do
        it "should disconnect the client" do
          @client.should_receive(:disconnect)
          @client.stub(:emit_ooc)
          @quit.on_command(@client, @cmd)
        end
        
        it "should send the bye text" do
          @client.stub(:disconnect)
          @client.should_receive(:emit_ooc).with("login.goodbye")
          @quit.on_command(@client, @cmd)
        end
      end
    end
  end
end