require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
  
    describe Connect do
      before do
        @connect = Connect.new
        @cmd = double
        @client = double
      end
      
      describe :want_command? do
        it "wants the connect command" do
          @cmd.stub(:root_is?).with("connect") { true }
          @connect.want_command?(@client, @cmd).should be_true
        end

        it "doesn't want another command" do
          @cmd.stub(:root_is?).with("connect") { false }
          @connect.want_command?(@client, @cmd).should be_false
        end
      end
     end
  end
end