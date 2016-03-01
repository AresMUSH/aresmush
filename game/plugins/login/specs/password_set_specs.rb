require_relative "../../plugin_test_loader"

module AresMUSH
  module Login  
    describe PasswordSetCmd do
      include CommandHandlerTestHelper
      
      before do
        init_handler(PasswordSetCmd, "password/set old=new")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that requires login"
           
      describe :handle do  
        before do
          char.stub(:change_password)
          char.stub(:save!)
          client.stub(:emit_success)
          char.stub(:compare_password).with("old") { true }
          handler.crack!
        end

        it "should fail if the old password doesn't match" do
          char.should_receive(:compare_password).with("old") { false }
          char.should_not_receive(:change_password)
          client.should_receive(:emit_failure).with('login.password_incorrect')
          handler.handle
        end
        
        it "should change the client's password" do
          char.should_receive(:change_password).with("new")
          char.should_receive(:save!)
          handler.handle
        end
          
        it "should emit to the client" do
          client.should_receive(:emit_success).with("login.password_changed")
          handler.handle
        end
      end
    end
  end
end