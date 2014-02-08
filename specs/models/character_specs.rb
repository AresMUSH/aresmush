$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Character do
    
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
  end
end