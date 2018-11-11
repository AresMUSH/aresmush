$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe Client do
    include GlobalTestHelper

    before do
      @connection = double
      allow(@connection).to receive(:ip_addr) { "1.2.3.4" }
      allow(Resolv).to receive(:getname).with("1.2.3.4") { "fake host" }
      @client = Client.new(1, @connection)
      stub_translate_for_testing
      stub_global_objects
    end

    describe :ping do
      it "should ping the connection" do
        expect(@connection).to receive(:ping)
        @client.ping
      end
    end

    describe :emit do
      it "should send the message to the connection with fansi enabled if char has it turned on" do
        char = double
        @client.char_id = 5
        allow(@client).to receive(:char) { char }
        allow(char).to receive(:fansi_on) { true }
        allow(char).to receive(:ascii_mode_enabled) { false }
        expect(@connection).to receive(:send_formatted).with("Hi", true, false)
        @client.emit "Hi"
      end
      
      it "should send the message to the connection with ASCII enabled if char has it turned on" do
        char = double
        @client.char_id = 5
        allow(@client).to receive(:char) { char }
        allow(char).to receive(:fansi_on) { false }
        allow(char).to receive(:ascii_mode_enabled) { true }
        expect(@connection).to receive(:send_formatted).with("Hi", false, true)
        @client.emit "Hi"
      end
    end
        
    describe :emit do
      it "should send the message to the connection" do
        expect(@connection).to receive(:send_formatted).with("Hi", false, false)
        @client.emit "Hi"
      end
    end

    describe :emit_ooc do
      it "should send the message with yellow ansi tags and %% prefix" do
        expect(@connection).to receive(:send_formatted).with("%xc%% OOC%xn", false, false)
        @client.emit_ooc "OOC"
      end
    end    
    
    describe :emit_success do
      it "should send the message with green ansi tags and %% prefix" do
        expect(@connection).to receive(:send_formatted).with("%xg%% Yay%xn", false, false)
        @client.emit_success "Yay"
      end
    end

    describe :emit_failure do
      it "sends the message with green ansi tags and %% prefix" do
        expect(@connection).to receive(:send_formatted).with("%xr%% Boo%xn", false, false)
        @client.emit_failure "Boo"
      end
    end
    
    describe :emit_raw do
      it "sends the raw text without formatting and with a linebreak" do
        expect(@connection).to receive(:send_data).with("%xr%%Boo%xn%r\r\n")
        @client.emit_raw "%xr%%Boo%xn%r"
      end
    end
    
    describe :handle_input do
      before do 
        allow(Global.logger).to receive(:error) do |msg| 
          raise msg
        end
      end
      
      it "should create a command and notify the dispatcher" do
        cmd = double
        expect(Command).to receive(:new).with("Yay") { cmd }
        expect(@dispatcher).to receive(:queue_command).with(@client, cmd)
        @client.handle_input "Yay\n"        
      end
      
      it "should concatenate split commands" do
        cmd = double
        expect(Command).to receive(:new).with("Yay!More!") { cmd }
        expect(@dispatcher).to receive(:queue_command).with(@client, cmd)
        @client.handle_input "Yay!"        
        @client.handle_input "More!\n"
      end
      
      it "should ignore null input" do
        expect(@dispatcher).to_not receive(:queue_command)
        @client.handle_input nil
      end
      
      it "should ignore empty input" do
        expect(@dispatcher).to_not receive(:queue_command)
        @client.handle_input "\n"
        @client.handle_input "\r\n"
        @client.handle_input "\n\n"
        @client.handle_input "      "
      end
    end

    describe :disconnect do
      it "should close the connection and flush output" do
        expect(@connection).to receive(:close_connection).with(true)
        @client.disconnect
      end
    end
    
    describe :connection_closed do
      it "should notify the client monitor that the connection closed" do
        expect(@client_monitor).to receive(:connection_closed).with(@client)
        @client.connection_closed
      end
    end 
    
    describe :idle_secs do
      it "should track the time since last activity" do
        @client.last_activity = Time.parse("2011-1-2 10:59:01")
        fake_now = Time.parse("2011-1-2 11:00:00")
        allow(Time).to receive(:now) { fake_now }
        expect(@client.idle_secs).to eq 59
      end
    end
    
    describe :connected_secs do
      it "should track the time since last connect" do
        @client.last_connect = Time.parse("2011-1-2 10:59:01")
        fake_now = Time.parse("2011-1-2 11:00:00")
        allow(Time).to receive(:now) { fake_now }
        expect(@client.connected_secs).to eq 59
      end
    end
    
    describe :ip_addr do
      it "should return the IP of the connection" do
        expect(@client.ip_addr).to eq "1.2.3.4"
      end
    end
    
    describe :hostname do
      it "should resolve the IP address" do
        expect(@client.hostname).to eq "fake host"
      end
    end 
   
    describe :char do
      it "should look up the char if there is one" do
        @client.char_id = 15
        found_char = double
        allow(Character).to receive(:[]).with(15) { found_char }
        expect(@client.char).to eq found_char
      end
     
      it "should return nil if not logged in" do
        @client.char_id = nil
        expect(@client.char).to eq nil
      end
    end
  end
end
