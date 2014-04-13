$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

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
    
    describe :has_role? do
      before do
        @char = Character.new
        @char.roles = [ "A" ]
      end
        
      it "should return true if the character has the role" do
        @char.has_role?("A").should be_true
      end
      
      it "should return false if they don't" do
        @char.has_role?("B").should be_false
      end
    end
    
    describe :has_any_role? do
      before do
        @char = Character.new
        @char.roles = [ "A", "B" ]
      end
      it "should return true if the character has a role in the list" do
        @char.has_any_role?([ "B", "C" ]).should be_true
      end
      
      it "should return false if they don't" do
        @char.has_any_role?([ "C", "D" ]).should be_false
      end
      
      it "should accept a single role" do
        @char.has_any_role?( "B" ).should be_true        
      end
    end
    
    describe :exists? do
      it "should return true if there is an existing char" do
        Character.stub(:find_by_name).with("Bob") { double }
        Character.exists?("Bob").should be_true
      end
      
      it "should return false if no char exists" do
        Character.stub(:find_by_name).with("Bob") { nil }
        Character.exists?("Bob").should be_false
      end
    end  
    
    describe :check_name do
      it "should fail if name is too short" do
        Character.check_name("Ab").should eq "validation.name_too_short"
      end
      
      it "should fail if the char already exists" do
        Character.stub(:exists?).with("Charname") { true }
        Character.check_name("Charname").should eq "validation.char_name_taken"
      end
      
      it "should fail if the char name starts with a lowercase letter" do
        Character.check_name("charname").should eq "validation.name_must_be_capitalized"        
      end

      it "should return true if everything's ok" do
        Character.stub(:exists?).with("Charname") { false }
        Character.check_name("Charname").should be_nil
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