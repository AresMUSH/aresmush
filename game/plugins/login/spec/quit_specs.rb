$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "quit"

module AresMUSH
  module Login
    describe Quit do
      before do
        @cmd = double(Command)
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
          client = double(Client)
          client.should_receive(:disconnect)
          @quit.on_command(client, @cmd)
        end
      end
    end
  end
end