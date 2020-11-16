module AresMUSH

  describe Character do
    before do
      stub_translate_for_testing
    end
    
    describe :hash_password do
      it "should use bcrypt to hash the password" do
        password = double(BCrypt::Password)
        expect(BCrypt::Password).to receive(:create).with("test") { password }
        expect(Character.hash_password("test")).to eq password
      end
    end
    
    describe :compare_password do
      it "should return true if passwords match" do
        char = Character.new
        allow(char).to receive(:save) {}
        char.change_password("existing_pw")
        expect(char.compare_password("existing_pw")).to be true
      end
      
      it "should return false if passwords don't match" do
        char = Character.new
        allow(char).to receive(:save) {}
        char.change_password("existing_pw")
        expect(char.compare_password("other_password")).to be false
      end
    end
    
    describe :check_name do
      before do
        allow(Global).to receive(:read_config).with("names", "restricted") { ["barney"] }
      end
      
      it "should fail if name is too short" do
        expect(Character.check_name("A")).to eq "validation.name_too_short"
      end
      
      it "should fail if name contains an invalid char" do
        expect(Character.check_name("A_BC")).to eq "validation.name_contains_invalid_chars"
        expect(Character.check_name("A BC")).to eq "validation.name_contains_invalid_chars"
        expect(Character.check_name("A.BC")).to eq "validation.name_contains_invalid_chars"
        expect(Character.check_name("B@ABC")).to eq "validation.name_contains_invalid_chars"
      end
      
      it "should disallow a restricted name" do
        allow(Character).to receive(:found?).with("Barney") { false }
        expect(Character.check_name("Barney")).to eq "validation.name_is_restricted"
      end
    end
    
    describe :check_password do
      it "should fail if password is too short" do
        expect(Character.check_password("bar")).to eq "validation.password_too_short"
      end
      
      it "should fail if the password has an equal sign" do
        expect(Character.check_password("bar=foo")).to eq "validation.password_cant_have_equals"
      end

      it "should return true if everything's ok" do
        expect(Character.check_password("password")).to be_nil
      end
    end  
  end
end
