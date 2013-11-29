require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe :validate_char_name do
      before do
        @client = double(Client)
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should fail if name is empty" do
        @client.should_receive(:emit_failure).with("login.invalid_create_syntax")
        Login.validate_char_name(@client, "").should be_false
      end
      
      it "should fail if the char already exists" do
        Character.stub(:exists?).with("charname") { true }
        @client.should_receive(:emit_failure).with("login.char_name_taken")
        Login.validate_char_name(@client, "charname").should be_false
      end

      it "should return true if everything's ok" do
        Character.stub(:exists?).with("charname") { false }
        Login.validate_char_name(@client, "charname").should be_true
      end
    end
    
    describe :validate_char_password do
      before do
        AresMUSH::Locale.stub(:translate).with("login.password_too_short") { "login.password_too_short" }
        @client = double(Client)
      end

      it "should fail if password is too short" do
        @client.should_receive(:emit_failure).with("login.password_too_short")
        Login.validate_char_password(@client, "bar").should be_false
      end

      it "should return true if everything's ok" do
        Character.stub(:exists?).with("charname") { false }
        Login.validate_char_password(@client, "password").should be_true
      end
    end
  end
end

