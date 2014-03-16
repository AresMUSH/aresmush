require_relative "../../plugin_test_loader"

module AresMUSH
  module Login  
    describe PasswordSetCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(PasswordSetCmd, "password old=new")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that requires login"
           
      describe :handle do  
        before do
          handler.crack!
        end
        
        it "should reset own password" do
          Character.should_receive(:find_by_name).with("Old") { nil }
          handler.should_receive(:handle_change_own_password)
          handler.handle
        end
        
        it "should reset another's password" do
          found_char = double
          Character.should_receive(:find_by_name).with("Old") { found_char }
          handler.should_receive(:handle_change_other_password) { found_char }
          handler.handle
        end
        
      end
      
      describe :handle_change_own_password do
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
          handler.handle_change_own_password
        end
        
        it "should change the client's password" do
          char.should_receive(:change_password).with("new")
          char.should_receive(:save!)
          handler.handle_change_own_password
        end
          
        it "should emit to the client" do
          client.should_receive(:emit_success).with("login.password_changed")
          handler.handle_change_own_password
        end
      end
      
      describe :handle_change_other_password do
        before do
          @found_char = double
          @found_char.stub(:change_password)
          @found_char.stub(:save!)
          client.stub(:emit_success)
          handler.crack!
          AresMUSH::Locale.stub(:translate).with("login.password_reset", { :name => "old" }) { "password_reset" }
        end
        
        it "should change the found char's password" do
          @found_char.should_receive(:change_password).with("new")
          @found_char.should_receive(:save!)
          handler.handle_change_other_password(@found_char)
        end
          
        it "should emit to the client" do
          client.should_receive(:emit_success).with("password_reset")
          handler.handle_change_other_password(@found_char)
        end
      end
    end
  end
end