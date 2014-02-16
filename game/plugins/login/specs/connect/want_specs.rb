require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
  
    describe Connect do
      before do
        @connect = Connect.new
      end
      
      describe :want_command? do
        it "wants the connect command" do
          cmd = double
          cmd.stub(:root_is?).with("connect") { true }
          @connect.want_command?(cmd).should be_true
        end

        it "doesn't want another command" do
          cmd = double
          cmd.stub(:root_is?).with("connect") { false }
          @connect.want_command?(cmd).should be_false
        end
      end
     end
  end
end