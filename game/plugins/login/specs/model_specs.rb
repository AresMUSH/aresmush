module AresMUSH

  describe Character do
    before do
      SpecHelpers.stub_translate_for_testing
    end
    
    describe :hash_password do
      it "should use bcrypt to hash the password" do
        password = double(BCrypt::Password)
        BCrypt::Password.should_receive(:create).with("test") { password }
        Character.hash_password("test").should eq password
      end
    end
    
    describe :compare_password do
      it "should return true if passwords match" do
        char = Character.new
        char.change_password("existing_pw")
        char.compare_password("existing_pw").should be_true
      end
      
      it "should return false if passwords don't match" do
        char = Character.new
        char.change_password("existing_pw")
        char.compare_password("other_password").should be_false
      end
    end
    
    describe :check_name do
      before do
        Global.stub(:config) { { "names" => { "restricted" => ["barney"] } } }
      end
      
      it "should fail if name is too short" do
        Character.check_name("A").should eq "validation.name_too_short"
      end
      
      it "should fail if name contains an invalid char" do
        Character.check_name("A_BC").should eq "validation.name_contains_invalid_chars"
        Character.check_name("A BC").should eq "validation.name_contains_invalid_chars"
        Character.check_name("A.BC").should eq "validation.name_contains_invalid_chars"
        Character.check_name("@ABC").should eq "validation.name_contains_invalid_chars"
      end
      
      it "should fail if the char already exists" do
        Character.stub(:found?).with("Charname") { true }
        Character.check_name("Charname").should eq "validation.char_name_taken"
      end
      
      it "should return true if everything's ok" do
        Character.stub(:found?).with("Charname") { false }
        Character.stub(:found?).with("O'Malley") { false }
        Character.stub(:found?).with("This-Char") { false }
        Character.check_name("Charname").should be_nil
        Character.check_name("O'Malley").should be_nil
        Character.check_name("This-Char").should be_nil
      end
      
      it "should disallow a restricted name" do
        Character.stub(:found?).with("Barney") { false }
        Character.check_name("Barney").should eq "validation.name_is_restricted"
      end
    end
    
    describe :check_password do
      it "should fail if password is too short" do
        Character.check_password("bar").should eq "validation.password_too_short"
      end
      
      it "should fail if the password has an equal sign" do
        Character.check_password("bar=foo").should eq "validation.password_cant_have_equals"
      end

      it "should return true if everything's ok" do
        Character.check_password("password").should be_nil
      end
    end  
  end
end