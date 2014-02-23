require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
  
    describe ConnectCmd do
      include CommandTestHelper
      
      before do
        init_handler(ConnectCmd, "connect Bob bobpassword")
        SpecHelpers.stub_translate_for_testing        
      end
            
      describe :want_command? do
        it "wants the connect command" do
          cmd.stub(:root_is?).with("connect") { true }
          handler.want_command?(client, cmd).should be_true
        end

        it "doesn't want another command" do
          cmd.stub(:root_is?).with("connect") { false }
          handler.want_command?(client, cmd).should be_false
        end
      end
     end
  end
end