require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe Quit do

      before do
        @cmd = double(Command)
        @client = double(Client).as_null_object      
        @quit = Quit.new
        SpecHelpers.stub_translate_for_testing
      end

      describe :want_command do
        it "should want the quit command if logged in" do
          @cmd.stub(:root_is?).with("quit") { true }
          @cmd.stub(:logged_in?) { true }
          @quit.want_command?(@cmd).should be_true
        end

        it "should want the quit command if not logged in" do
          @cmd.stub(:root_is?).with("quit") { true }
          @cmd.stub(:logged_in?) { false }
          @quit.want_command?(@cmd).should be_true
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("quit") { false }
          @cmd.stub(:logged_in?) { true }
          @quit.want_command?(@cmd).should be_false
        end        
      end

      describe :on_command do
        it "should disconnect the client" do
          @client.should_receive(:disconnect)
          @quit.on_command(@client, @cmd)
        end
        
        it "should send the bye text" do
          @client.should_receive(:emit_ooc).with("login.goodbye")
          @quit.on_command(@client, @cmd)
        end
      end
    end
  end
end