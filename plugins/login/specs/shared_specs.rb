module AresMUSH
  module Login
    describe Login do
      describe :can_access_email? do
        before do
          @actor = double
          @other_char = double
          Global.stub(:read_config).with("login", "manage_login") { ['admin'] }
        end
          
        it "should allow you to see your own email" do
          Login.can_access_email?(@actor, @actor).should be true
        end
        
        it "should allow someone with the required role to see email" do
          @actor.stub(:has_permission?).with("manage_login") { true }
          Login.can_access_email?(@actor, @other_char).should be true
        end
        
        it "should not allow you to access someone else's email" do
          @actor.stub(:has_permission?).with("manage_login") { false }
          Login.can_access_email?(@actor, @other_char).should be false
        end
      end
      
      describe :can_manage_login? do
        before do
          @actor = double
        end
          
        it "should allow someone with the required role to reset a password" do
          @actor.stub(:has_permission?).with("manage_login") { true }
          Login.can_manage_login?(@actor).should be true
        end
        
        it "should not allow you to reset a password" do
          @actor.stub(:has_permission?).with("manage_login") { false }
          Login.can_manage_login?(@actor).should be false
        end
      end
      
      describe :wants_announce do
        before do
          @listener = double
          @connector = double
        end
        
        it "should want announce if you're listening for everybody" do
          @listener.stub(:login_watch) { "all" }
          Login.wants_announce(@listener, @connector).should eq true
        end 
        
        it "should not want announce if you've disabled it" do
          @listener.stub(:login_watch) { "none" }
          Login.wants_announce(@listener, @connector).should eq false
        end
        
        it "should not want announce if friends-only and have not friended a char" do
          @listener.stub(:login_watch) { "friends" }
          @listener.stub(:is_friend?).with(@connector) { false }
          Login.wants_announce(@listener, @connector).should eq false
        end
        
        it "should want announce if friends-only and have friended a  handle" do
          @listener.stub(:login_watch) { "friends" }
          @listener.stub(:is_friend?).with(@connector) { true }
          Login.wants_announce(@listener, @connector).should eq true
        end
        
      end
    end
  end
end