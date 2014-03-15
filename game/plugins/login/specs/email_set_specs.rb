require_relative "../../plugin_test_loader"

module AresMUSH
  module Login  
    describe EmailSetCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(EmailSetCmd, "email/set foo@bar.com")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that requires login"
           
      describe :handle do  
        before do
          char.stub(:email=)
          char.stub(:save!)
          client.stub(:emit_success)
        end

        it "should set the email" do
          handler.stub(:email) { "foo@bar.com" }
          char.should_receive(:email=).with("foo@bar.com")
          char.should_receive(:save!)
          handler.handle
        end
          
        it "should emit to the client" do
          client.should_receive(:emit_success).with("login.email_set")
          handler.handle
        end
      end
    end
  end
end