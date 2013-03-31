require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe Quit do

      before do
        AresMUSH::Locale.stub(:translate).with("login.goodbye") { "bye" }        
        @cmd = double(Command)
        @client = double(Client).as_null_object      
        @quit = Quit.new(nil)
      end

      describe :want_command do
        it "should want the quit command" do
          @cmd.stub(:root_is?).with("quit") { true }
          @quit.want_command?(@cmd).should be_true
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("quit") { false }
          @quit.want_command?(@cmd).should be_false
        end        
      end

      describe :want_anon_command do
        it "should want the quit command" do
          @cmd.stub(:root_is?).with("quit") { true }
          @quit.want_anon_command?(@cmd).should be_true
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("quit") { false }
          @quit.want_anon_command?(@cmd).should be_false
        end        
      end

      describe :on_command do
        it "should disconnect the client" do
          @client.should_receive(:disconnect)
          @quit.on_command(@client, @cmd)
        end
        
        it "should send the bye text" do
          @client.should_receive(:emit_ooc).with("bye")
          @quit.on_command(@client, @cmd)
        end
      end
    end
  end
end