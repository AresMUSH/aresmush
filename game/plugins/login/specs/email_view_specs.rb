require_relative "../../plugin_test_loader"

module AresMUSH
  module Login  
    describe EmailViewCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(EmailViewCmd, "email")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :crack do
        it "should set the name if specified" do
          init_handler(EmailViewCmd, "email bob")
          handler.crack!
          handler.name.should eq "bob"
        end
        
        it "should default to client's name if no name specified" do
          init_handler(EmailViewCmd, "email")
          client.stub(:name) { "client name" }
          handler.crack!
          handler.name.should eq "client name"
        end   
      end  
     
      describe :handle do  
        
        context "not found" do
          it "should fail if there isn't a matching char" do
            handler.stub(:name) { "Bob" }
            Character.should_receive(:find_all_by_name_or_id).with("Bob") { nil }
            client.should_receive(:emit_failure).with("db.object_not_found")
            handler.handle
          end
        end

        context "not allowed" do
          it "should fail if the actor doesn't have permission" do
            handler.stub(:name) { "Bob" }
            @found_char = double
            Character.stub(:find_all_by_name_or_id) { [@found_char] }
            Login.stub(:can_access_email?).with(char, @found_char) { false }
            client.should_receive(:emit_failure).with("dispatcher.not_allowed")
            handler.handle
          end
        end
        
        context "success" do
          before do
            handler.stub(:name) { "Bob" }
            @found_char = double
            Character.should_receive(:find_all_by_name_or_id).with("Bob") { [@found_char] }
            Login.stub(:can_access_email?).with(char, @found_char) { true }
            AresMUSH::Locale.stub(:translate).with("login.email_registered_is", { :name => "Bob", :email => "foo@bar.com" }) { "email_is" }
            AresMUSH::Locale.stub(:translate).with("login.no_email_is_registered", { :name => "Bob" }) { "no_email_registered" }
          end
       
          it "should emit the email if set" do
            @found_char.stub(:email) { "foo@bar.com" }
            client.should_receive(:emit_ooc).with("email_is")
            handler.handle
          end

          it "should emit the no email msg if not set" do
            @found_char.stub(:email) { nil }
            client.should_receive(:emit_ooc).with("no_email_registered")
            handler.handle
          end
        end
      end
    end
  end
end