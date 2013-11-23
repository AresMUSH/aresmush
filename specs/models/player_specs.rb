$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Character do
    it "should extend AresModel" do
      Character.kind_of?(AresModel).should be_true
    end
    
    describe :coll do 
      it "should return the chars collection" do
        Character.coll.should eq :chars
      end
    end
    
    describe :custom_model_fields do
      it "should set the uppercase name" do
        model = {"name" => "Bob", "foo" => "test"}
        model = Character.custom_model_fields(model)
        model.should include( "name_upcase" => "BOB" )
      end
      
       it "should set the object type" do
          model = {"name" => "Bob", "foo" => "test"}
          model = Character.custom_model_fields(model)
          model.should include( "type" => "Character" )
        end
    end
    
    describe :hash_password do
      it "should use bcrypt to hash the password" do
        password = double(BCrypt::Password)
        BCrypt::Password.should_receive(:create).with("test") { password }
        Character.hash_password("test").should eq password
      end
    end
    
    describe :compare_password do
      it "should use the bcrypt compare" do
        password = double(BCrypt::Password)
        BCrypt::Password.should_receive(:new).with("existing_pw") { password }
        password.should_receive(:==).with("test_pw")
        char = { "password" => "existing_pw" }
        Character.compare_password(char, "test_pw")
      end
    end
    
    describe :exists? do
      it "should return true if there is an existing char" do
        Character.stub(:find_by_name).with("Bob") { [double] }
        Character.exists?("Bob").should be_true
      end
      
      it "should return false if no char exists" do
        Character.stub(:find_by_name).with("Bob") { [] }
        Character.exists?("Bob").should be_false
      end
    end
    
    describe :create_char do
      it "should set the name" do
        Character.should_receive(:create) do |args|
          args["name"].should eq "Bob"
        end
        Character.create_char("Bob", "bobs_password")
      end
      
      it "should hash the password" do
        Character.should_receive(:hash_password).with("bobs_password") { "hashed_password" }
        Character.should_receive(:create) do |args|
          args["password"].should eq "hashed_password"
        end
        Character.create_char("Bob", "bobs_password")
      end
    end
  end
end