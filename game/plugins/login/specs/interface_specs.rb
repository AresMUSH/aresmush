require_relative "../../plugin_test_loader"

module AresMUSH
  describe AresMUSH::Login do
    before do
      SpecHelpers.stub_translate_for_testing
    end

    describe :check_char_name do
      it "should fail if name is too short" do
        Login.check_char_name("Ab").should eq "login.name_too_short"
      end
      
      it "should fail if the char already exists" do
        Character.stub(:exists?).with("Charname") { true }
        Login.check_char_name("Charname").should eq "login.char_name_taken"
      end
      
      it "should fail if the char name starts with a lowercase letter" do
        Login.check_char_name("charname").should eq "login.name_must_be_capitalized"        
      end

      it "should return true if everything's ok" do
        Character.stub(:exists?).with("Charname") { false }
        Login.check_char_name("Charname").should be_nil
      end
    end
    
    describe :check_char_password do
      it "should fail if password is too short" do
        Login.check_char_password("bar").should eq "login.password_too_short"
      end
      
      it "should fail if the password has an equal sign" do
        Login.check_char_password("bar=foo").should eq "login.password_cant_have_equals"
      end

      it "should return true if everything's ok" do
        Login.check_char_password("password").should be_nil
      end
    end
  end
end

