require_relative "../../plugin_test_loader"

module AresMUSH
  module Login  
    describe PasswordResetCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(PasswordResetCmd, "password/reset name=new")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that requires login"
           
      describe :handle do  
        before do
          handler.crack!
          @found_char = double
          @found_char.stub(:change_password)
          @found_char.stub(:save!)
          client.stub(:emit_success)
          Character.stub(:find_all_by_name_or_id).with("name") { [@found_char] }
          AresMUSH::Locale.stub(:translate).with("login.password_reset", { :name => "name" }) { "password_reset" }
        end
                
        it "should change the found char's password" do
          @found_char.should_receive(:change_password).with("new")
          @found_char.should_receive(:save!)
          handler.handle
        end
          
        it "should emit to the client" do
          client.should_receive(:emit_success).with("password_reset")
          handler.handle
        end
      end
    end
  end
end