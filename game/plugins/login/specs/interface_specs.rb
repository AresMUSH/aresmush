require_relative "../../plugin_test_loader"

module AresMUSH
  describe AresMUSH::Login do
    before do
      SpecHelpers.stub_translate_for_testing
    end

    describe :validate_char_name do
      it "should fail if name is too short" do
        Login.validate_char_name("ab").should eq "login.name_too_short"
      end
      
      it "should fail if the char already exists" do
        Character.stub(:exists?).with("charname") { true }
        Login.validate_char_name("charname").should eq "login.char_name_taken"
      end

      it "should return true if everything's ok" do
        Character.stub(:exists?).with("charname") { false }
        Login.validate_char_name("charname").should be_nil
      end
    end
    
    describe :validate_char_password do
      it "should fail if password is too short" do
        Login.validate_char_password("bar").should eq "login.password_too_short"
      end
      
      it "should fail if the password has an equal sign" do
        Login.validate_char_password("bar=foo").should eq "login.password_cant_have_equals"
      end

      it "should return true if everything's ok" do
        Login.validate_char_password("password").should be_nil
      end
    end
  end
end

