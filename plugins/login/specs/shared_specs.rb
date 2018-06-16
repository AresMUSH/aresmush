module AresMUSH
  module Login
    describe Login do
      describe :can_access_email? do
        before do
          @actor = double
          @other_char = double
          allow(Global).to receive(:read_config).with("login", "manage_login") { ['admin'] }
        end
          
        it "should allow you to see your own email" do
          expect(Login.can_access_email?(@actor, @actor)).to be true
        end
        
        it "should allow someone with the required role to see email" do
          allow(@actor).to receive(:has_permission?).with("manage_login") { true }
          expect(Login.can_access_email?(@actor, @other_char)).to be true
        end
        
        it "should not allow you to access someone else's email" do
          allow(@actor).to receive(:has_permission?).with("manage_login") { false }
          expect(Login.can_access_email?(@actor, @other_char)).to be false
        end
      end
      
      describe :can_manage_login? do
        before do
          @actor = double
        end
          
        it "should allow someone with the required role to reset a password" do
          allow(@actor).to receive(:has_permission?).with("manage_login") { true }
          expect(Login.can_manage_login?(@actor)).to be true
        end
        
        it "should not allow you to reset a password" do
          allow(@actor).to receive(:has_permission?).with("manage_login") { false }
          expect(Login.can_manage_login?(@actor)).to be false
        end
      end
      
      describe :wants_announce do
        before do
          @listener = double
          @connector = double
        end
        
        it "should want announce if you're listening for everybody" do
          allow(@listener).to receive(:login_watch) { "all" }
          expect(Login.wants_announce(@listener, @connector)).to eq true
        end 
        
        it "should not want announce if you've disabled it" do
          allow(@listener).to receive(:login_watch) { "none" }
          expect(Login.wants_announce(@listener, @connector)).to eq false
        end
        
        it "should not want announce if friends-only and have not friended a char" do
          allow(@listener).to receive(:login_watch) { "friends" }
          allow(@listener).to receive(:is_friend?).with(@connector) { false }
          expect(Login.wants_announce(@listener, @connector)).to eq false
        end
        
        it "should want announce if friends-only and have friended a  handle" do
          allow(@listener).to receive(:login_watch) { "friends" }
          allow(@listener).to receive(:is_friend?).with(@connector) { true }
          expect(Login.wants_announce(@listener, @connector)).to eq true
        end
        
      end
    end
  end
end
