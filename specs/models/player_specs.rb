$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Player do
    it "should extend AresModel" do
      Player.kind_of?(AresModel).should be_true
    end
    
    describe :coll do 
      it "should return the players collection" do
        Player.coll.should eq :players
      end
    end
    
    describe :custom_model_fields do
      it "should set the uppercase name" do
        model = {"name" => "Bob", "foo" => "test"}
        model = Player.custom_model_fields(model)
        model.should include( "name_upcase" => "BOB" )
      end
      
       it "should set the object type" do
          model = {"name" => "Bob", "foo" => "test"}
          model = Player.custom_model_fields(model)
          model.should include( "type" => "Player" )
        end
    end
    
    describe :hash_password do
      it "should use bcrypt to hash the password" do
        password = double(BCrypt::Password)
        BCrypt::Password.should_receive(:create).with("test") { password }
        Player.hash_password("test").should eq password
      end
    end
    
    describe :compare_password do
      it "should use the bcrypt compare" do
        password = double(BCrypt::Password)
        BCrypt::Password.should_receive(:new).with("existing_pw") { password }
        password.should_receive(:==).with("test_pw")
        player = { "password" => "existing_pw" }
        Player.compare_password(player, "test_pw")
      end
    end
    
  end
end