# No args - error and return
# No player - error
# Ambiguous players - error
# Invalid password - error
# Send connected event


$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "connect"

module AresMUSH
  module Login
  
    describe Connect do
      before do
        @contianer = Container.new(nil, nil, nil, nil, nil)
        @connect = Connect.new(@container)
      end
      
      describe :want_command? do
        it "doesn't want any commands" do
          cmd = mock
          @connect.want_command?(cmd).should be_false
        end
      end

      describe :want_anon_command? do
        it "wants the connect command" do
          cmd = mock
          cmd.stub(:root_is?).with("connect") { true }
          @connect.want_anon_command?(cmd).should be_true
        end

        it "doesn't want another command" do
          cmd = mock
          cmd.stub(:root_is?).with("connect") { false }
          @connect.want_anon_command?(cmd).should be_false
        end
      end
      
      
    end
  end
end