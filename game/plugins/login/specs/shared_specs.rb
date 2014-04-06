module AresMUSH
  module Login
    describe Login do
      describe :can_access_email? do
        before do
          @actor = double
          @other_char = double
          Global.stub(:config) {{ "login" => { "roles" => { "can_access_email" => ['admin'] }}}}
        end
          
        it "should allow you to see your own email" do
          Login.can_access_email?(@actor, @actor).should be_true
        end
        
        it "should allow someone with the required role to see email" do
          @actor.stub(:has_any_role?).with(["admin"]) { true }
          Login.can_access_email?(@actor, @other_char).should be_true
        end
        
        it "should not allow you to access someone else's email" do
          @actor.stub(:has_any_role?).with(["admin"]) { false }
          Login.can_access_email?(@actor, @other_char).should be_false
        end
      end
      
      describe :can_reset_password? do
        before do
          @actor = double
          Global.stub(:config) {{ "login" => { "roles" => { "can_reset_password" => ['admin'] }}}}
        end
          
        it "should allow someone with the required role to reset a password" do
          @actor.stub(:has_any_role?).with(["admin"]) { true }
          Login.can_reset_password?(@actor).should be_true
        end
        
        it "should not allow you to access someone else's email" do
          @actor.stub(:has_any_role?).with(["admin"]) { false }
          Login.can_reset_password?(@actor).should be_false
        end
      end
    end
  end
end