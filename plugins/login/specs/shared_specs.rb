module AresMUSH
  module Login
    describe Login do
      include GlobalTestHelper

      before do
        stub_global_objects
        stub_translate_for_testing
      end
      
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
      
      describe :is_banned? do
        before do
          @char = double
          allow(Global).to receive(:read_config).with("sites", "banned") { [ "123.45.678" ] }
          allow(config_reader).to receive(:get_text).with("blacklist.txt") { "234.56.789\n345.67.890" }
        end
        
        it "should never ban an admin" do
          allow(@char).to receive(:is_admin?) { true }
          expect(Login.is_banned?(@char, "123.45.678", "somehost")).to eq false
        end
        
        it "should block someone on the ban list" do
          allow(@char).to receive(:is_admin?) { false }
          expect(Login.is_banned?(@char, "123.45.678", "somehost")).to eq true
        end
        
        it "should not check the proxy blacklist if disabled" do
          allow(@char).to receive(:is_admin?) { false }
          allow(Global).to receive(:read_config).with("sites", "ban_proxies") { false }
          expect(Login.is_banned?(@char, "345.67.890", "somehost")).to eq false
          
        end
      
        context "proxy enabled" do
          before do
            allow(Global).to receive(:read_config).with("sites", "ban_proxies") { true }
            allow(@char).to receive(:is_admin?) { false }
          end
          
          it "should not check the proxy blacklist for an approved char" do
            expect(@char).to receive(:is_approved?) { true }
            expect(Login.is_banned?(@char, "345.67.890", "somehost")).to eq false            
          end
        
          it "should check the proxy blacklist for an anonymous char" do
            expect(Login.is_banned?(nil, "345.67.890", "somehost")).to eq true            
          end

          it "should check the proxy blacklist for a non-approved char" do
            expect(@char).to receive(:is_approved?) { false }
            expect(Login.is_banned?(@char, "345.67.890", "somehost")).to eq true            
          end
        end
      end
      
      describe :is_site_match? do
        it "should match an IP" do
          expect(Login.is_site_match?("123.45.67.89", "", "123.45.67.89", "somesite.com")).to eq true
        end

        it "should match a host" do
          expect(Login.is_site_match?("", "somesite.com", "111", "somesite.com")).to eq true
        end

        it "should match a partial IP" do
          expect(Login.is_site_match?("123.45.67.89.111", "", "123.45", "somesite.com")).to eq true
        end

        it "should match a partial host" do
          expect(Login.is_site_match?("", "pa.142.xyz.abc.somesite.com", "123.45", "somesite.com")).to eq true
        end
        
        it "should not match a different IP" do
          expect(Login.is_site_match?("234.56.78.90", "", "123.45.67.89", "somesite.com")).to eq false
        end

        it "should not match a different host" do
          expect(Login.is_site_match?("othersite.com", "", "123.45.67.89", "somesite.com")).to eq false
        end
        
      end
      
      describe :name_taken? do
        before do
          @found_char = double
          allow(Character).to receive(:find_one_by_name).with("Charname") { nil }
          allow(Global).to receive(:read_config).with("names", "restricted") { ["barney"] }
        end

        it "should fail if the char name already exists" do
          allow(Character).to receive(:find_one_by_name).with("Existing") { @found_char }
          allow(@found_char).to receive(:name_upcase) { "EXISTING" }
          expect(Login.name_taken?("Existing")).to eq "validation.char_name_taken"
        end

        it "should fail if the char alias already exists" do
          allow(Character).to receive(:find_one_by_name).with("Existing") { @found_char }
          allow(@found_char).to receive(:name_upcase) { "FOO" }
          allow(@found_char).to receive(:alias_upcase) { "EXISTING" }
          expect(Login.name_taken?("Existing")).to eq "validation.char_name_taken"
        end
      
        it "should allow a subset of an existing name" do
          allow(Character).to receive(:find_one_by_name).with("Exi") { @found_char }
          allow(@found_char).to receive(:name_upcase) { "EXISTING" }
          allow(@found_char).to receive(:alias_upcase) { nil }
          expect(Login.name_taken?("Exi", @found_char)).to be_nil
        end
      
        it "should allow a subset of an existing alias" do
          allow(Character).to receive(:find_one_by_name).with("Exi") { @found_char }
          allow(@found_char).to receive(:name_upcase) { "FOO" }
          allow(@found_char).to receive(:alias_upcase) { "EXISTING" }
          expect(Login.name_taken?("Exi", @found_char)).to be_nil
        end
        
        it "should let them hvae their own name" do
          allow(Character).to receive(:find_one_by_name).with("Existing") { @found_char }
          allow(@found_char).to receive(:name_upcase) { "FOO" }
          allow(@found_char).to receive(:alias_upcase) { "EXISTING" }
          expect(Login.name_taken?("Existing", @found_char)).to be_nil
        end
      
        it "should return true if everything's ok" do
          allow(Character).to receive(:find_one_by_name).with("Charname") { nil }
          allow(Character).to receive(:find_one_by_name).with("O'Malley") { nil }
          allow(Character).to receive(:find_one_by_name).with("This-Char") { nil }
          expect(Login.name_taken?("Charname")).to be_nil
          expect(Login.name_taken?("O'Malley")).to be_nil
          expect(Login.name_taken?("This-Char")).to be_nil
        end
      end
    end
  end
end
