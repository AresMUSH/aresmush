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
          @game = double
          allow(Game).to receive(:master) { @game }
          allow(@game).to receive(:banned_sites) { { "123.45.678" => "Reason" }}
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
          @char = double
          allow(Character).to receive(:find_one_by_name).with("Charname") { nil }
          allow(Global).to receive(:read_config).with("names", "restricted") { ["barney"] }
        end

        it "should fail if the char name already exists" do
          allow(Character).to receive(:find_one_by_name).with("Existing") { @char }
          allow(@char).to receive(:name_upcase) { "EXISTING" }
          expect(Login.name_taken?("Existing")).to eq "validation.char_name_taken"
        end

        it "should fail if the char alias already exists" do
          allow(Character).to receive(:find_one_by_name).with("Existing") { @char }
          allow(@char).to receive(:name_upcase) { "FOO" }
          allow(@char).to receive(:alias_upcase) { "EXISTING" }
          expect(Login.name_taken?("Existing")).to eq "validation.char_name_taken"
        end
      
        it "should allow a subset of an existing name" do
          allow(Character).to receive(:find_one_by_name).with("Exi") { @char }
          allow(@char).to receive(:name_upcase) { "EXISTING" }
          allow(@char).to receive(:alias_upcase) { nil }
          expect(Login.name_taken?("Exi", @char)).to be_nil
        end
      
        it "should allow a subset of an existing alias" do
          allow(Character).to receive(:find_one_by_name).with("Exi") { @char }
          allow(@char).to receive(:name_upcase) { "FOO" }
          allow(@char).to receive(:alias_upcase) { "EXISTING" }
          expect(Login.name_taken?("Exi", @char)).to be_nil
        end
        
        it "should let them hvae their own name" do
          allow(Character).to receive(:find_one_by_name).with("Existing") { @char }
          allow(@char).to receive(:name_upcase) { "FOO" }
          allow(@char).to receive(:alias_upcase) { "EXISTING" }
          expect(Login.name_taken?("Existing", @char)).to be_nil
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
      
      describe :in_boot_timeout? do
        before do
          @char = double
        end
        
        it "should return false if not booted" do
          allow(@char).to receive(:boot_timeout) { nil }
          expect(Login.in_boot_timeout?(@char)).to eq false
        end
        
        it "should return true if under timeout" do
          # Booted until 3:01, now 3:00
          allow(@char).to receive(:boot_timeout) { Time.new(2022, 01, 02, 3, 1, 0) }
          allow(Time).to receive(:now) { Time.new(2022, 01, 02, 3, 0, 0) }
                    
          expect(Login.in_boot_timeout?(@char)).to eq true
        end
        
        it "should return true if over timeout" do
          # Booted until 3:05, now 3:05:01
          allow(@char).to receive(:boot_timeout) { Time.new(2022, 01, 02, 3, 5, 0) }
          allow(Time).to receive(:now) { Time.new(2022, 01, 02, 3, 5, 1) }
                    
          expect(Login.in_boot_timeout?(@char)).to eq false
        end
      end
      
      describe :check_login do
        before do
          @char = double
          allow(@char).to receive(:is_admin?) { false }
          allow(@char).to receive(:name) { "Bob" }
          allow(AresCentral).to receive(:check_for_forgotten_password) { false }
          
          # Assume conditions to allow login
          allow(@char).to receive(:is_statue?) { false }
          allow(Login).to receive(:can_login?) { true }
          allow(@char).to receive(:boot_timeout) { nil }
          allow(Login).to receive(:is_banned?) { false }
          allow(@char).to receive(:login_failures) { 0 }
        end
        
        context "failure" do
                         
          it "should fail if the passwords don't match and update login failures" do
            expected_status = { status: 'error', error: "login.password_incorrect" }
            expect(@char).to receive(:compare_password).with("password") { false }
            allow(@char).to receive(:login_failures) { 1 }
            expect(@char).to receive(:update).with(login_failures: 2)
            expect(Global).to_not receive(:queue_event)
            expect(Login.check_login(@char, "password", "ip", "host")).to eq expected_status
          end
          
          it "should fail if the passwords don't match and too many login failures" do
            expected_status = { status: 'error', error: "login.password_locked" }
            expect(@char).to receive(:compare_password).with("password") { false }
            allow(@char).to receive(:login_failures) { 6 }
            expect(Global).to_not receive(:queue_event)
            expect(Login.check_login(@char, "password", "ip", "host")).to eq expected_status
          end
          
          it "should fail if char is a statue" do
            expected_status = { status: 'error', error: "dispatcher.you_are_statue" }
            expect(@char).to receive(:is_statue?) { true }
            expect(Global).to_not receive(:queue_event)
            expect(Login.check_login(@char, "password", "ip", "host")).to eq expected_status
          end
          
          it "should fail if the char isn't allowed to log in due to restricted logins" do
            expected_status = { status: 'error', error: "login.login_restricted" }
            expect(Login).to receive(:can_login?) { false }
            expect(Login).to receive(:restricted_login_message) { "" }
            expect(Login.check_login(@char, "password", "ip", "host")).to eq expected_status
          end
          
          it "should fail if the char isn't allowed to log in due to site matching" do
            allow(Login).to receive(:site_blocked_message) { "site blocked" }
            expected_status = { status: 'error', error: "site blocked" }
            expect(Login).to receive(:is_banned?).with(@char, "ip", "host") { true }
            expect(Login.check_login(@char, "password", "ip", "host")).to eq expected_status
          end
          
          it "should fail if the char is in boot timeout" do
            expected_status = { status: 'error', error: "login.you_are_in_timeout" }
            expect(Login).to receive(:can_login?) { true }
            allow(@char).to receive(:boot_timeout) { Time.now + 100 }
            allow(OOCTime).to receive(:local_long_timestr) { "date" }
            expect(Login.check_login(@char, "password", "ip", "host")).to eq expected_status
          end
          
        end
        
        context "success" do
          
          it "should allow login if passwords match" do
            expected_status = { status: 'ok' }
            expect(@char).to receive(:compare_password).with("password") { true }
            expect(Login.check_login(@char, "password", "ip", "host")).to eq expected_status
          end
          
          
          it "should allow them in if their boot timeout is over" do
            expected_status = { status: 'ok' }
            expect(@char).to receive(:compare_password).with("password") { true }
            allow(@char).to receive(:boot_timeout) { Time.now - 1 }
            expect(Login.check_login(@char, "password", "ip", "host")).to eq expected_status
          end
          
          it "should allow them in if their password doesn't match but AresC authorizes" do
            expected_status = { status: 'unlocked' }
            expect(@char).to receive(:compare_password).with("password") { false }
            expect(AresCentral).to receive(:check_for_forgotten_password).with(@char, "password") { true }

            expect(@char).to receive(:change_password).with("password")
            expect(@char).to receive(:update).with({ login_failures: 0})
            
            expect(Login.check_login(@char, "password", "ip", "host")).to eq expected_status
          end
          
          
        end
      end
      
      describe :boot_char do
        before do
          @enactor = double
          @bootee = double
          
          allow(@enactor).to receive(:name) { "Enactor" }
          allow(@bootee).to receive(:name) { "Bootee" }
          allow(@enactor).to receive(:is_admin?) { false }
          allow(@bootee).to receive(:is_admin?) { false }
          
          allow(Global).to receive(:read_config).with('login', 'boot_timeout_seconds') { 60 }
          allow(Global).to receive(:read_config).with('jobs', 'trouble_category') { "Trouble" }
          allow(Website).to receive(:activity_status) { "web-active" }
        end
        
        context "failure" do
          it "should not let a non-admin boot an admin" do
            allow(@enactor).to receive(:is_admin?) { false }
            allow(@bootee).to receive(:is_admin?) { true }
          
            expect(Login.boot_char(@enactor, @bootee, "Reasons")).to eq "login.cant_boot_admin"
          end
          
          it "should not boot someone who isn't connected" do
            expect(Website).to receive(:activity_status).with(@bootee) { "offline" }
            expect(Login.boot_char(@enactor, @bootee, "Reasons")).to eq "login.cant_boot_disconnected_player"
          end
        end

        context "success" do

          before do
            @client = double
            @system_char = double
            master_game = double

            allow(client_monitor).to receive(:clients) { [] }
            allow(Game).to receive(:master) { master_game }
            allow(master_game).to receive(:system_character) { @system_char }
            allow(Login).to receive(:notify)
            allow(Login).to receive(:find_client) { nil }
            allow(@bootee).to receive(:update)
            allow(@bootee).to receive(:last_ip) { "ip" }
            allow(@bootee).to receive(:last_hostname) { "host" }
            allow(Jobs).to receive(:create_job) { {job: double}}
            allow(Jobs).to receive(:comment) 
            allow(OOCTime).to receive(:local_long_timestr) { "date" } 
          end
          
          it "should let a non-admin boot a non-admin" do
            allow(@enactor).to receive(:is_admin?) { false }
            allow(@bootee).to receive(:is_admin?) { false }
          
            expect(Login.boot_char(@enactor, @bootee, "Reasons")).to eq nil
          end
          
          it "should let an admin boot an admin" do
            allow(@enactor).to receive(:is_admin?) { true }
            allow(@bootee).to receive(:is_admin?) { true }
          
            expect(Login.boot_char(@enactor, @bootee, "Reasons")).to eq nil
          end
          
          it "should set their boot timeout" do
            fake_now = Time.new(2022, 01, 02, 3, 0, 0)
            boot_timeout = fake_now + 60
            allow(Time).to receive(:now) { fake_now }
            expect(@bootee).to receive(:update).with( { boot_timeout: boot_timeout })
          
            expect(Login.boot_char(@enactor, @bootee, "Reasons")).to eq nil
          end
          
          it "should notify them they were booted" do
            expect(Login).to receive(:notify).with(@bootee, :system, 'login.you_have_been_booted', '')
            expect(Login.boot_char(@enactor, @bootee, "Reasons")).to eq nil
          end
          
          it "should boot them from the game" do
            expect(Login).to receive(:find_client).with(@bootee) { @client }
            expect(@client).to receive(:emit_failure).with("login.you_have_been_booted")
            expect(@client).to receive(:disconnect)
            expect(Login.boot_char(@enactor, @bootee, "Reasons")).to eq nil
          end
          
          it "should boot them from the portal" do
            expect(client_monitor).to receive(:clients) { [ @client ]}
            expect(@client).to receive(:web_char_id) { "22" }
            expect(@bootee).to receive(:id) { "22" }
            expect(@bootee).to receive(:update).with({ login_api_token: nil })
            expect(@client).to receive(:disconnect)
            expect(Login.boot_char(@enactor, @bootee, "Reasons")).to eq nil
          end
          
          it "should not boot someone else from the portal" do
            expect(client_monitor).to receive(:clients) { [ @client ]}
            expect(@client).to receive(:web_char_id) { "4" }
            expect(@bootee).to receive(:id) { "22" }
            expect(@bootee).to receive(:update).with({ login_api_token: nil })
            expect(@client).to_not receive(:disconnect)
            expect(Login.boot_char(@enactor, @bootee, "Reasons")).to eq nil
          end
          
        end
        
      end
      
      describe :can_login do
        before do
          @char = double
          allow(@char).to receive(:is_admin?) { false  }
          allow(Global).to receive(:read_config).with("login", "disable_nonadmin_logins") { false }
          allow(@char).to receive(:has_permission?).with("login") { true }
        end
        
        it "should always allow admins" do
          expect(@char).to receive(:is_admin?) { true }
          allow(Global).to receive(:read_config).with("login", "disable_nonadmin_logins") { true }
          expect(Login.can_login?(@char)).to eq true
        end
        
        it "should not allow nonadmins if disabled" do
          allow(Global).to receive(:read_config).with("login", "disable_nonadmin_logins") { true }
          expect(Login.can_login?(@char)).to eq false
        end

        it "should not allow nonadmins if permission missing" do
          allow(@char).to receive(:has_permission?).with("login") { false }
          expect(Login.can_login?(@char)).to eq false
        end

        it "should allow nonadmins if permission present" do
          expect(Login.can_login?(@char)).to eq true
        end
      end
      
    end
  end
end
