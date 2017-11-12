$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe Client do
    include GlobalTestHelper

    before do
      @connection = double
      @connection.stub(:ip_addr) { "1.2.3.4" }
      Resolv.stub("getname").with("1.2.3.4") { "fake host" }
      @client = Client.new(1, @connection)
      SpecHelpers.stub_translate_for_testing
      stub_global_objects
    end

    describe :connected do
      it "should greet the client with the connect config" do
        connect_config = { 'welcome_text' => "Hi", 'welcome_screen' => "Ascii Art" }
        ClientGreeter.should_receive(:greet).with(@client)
        @client.connected
      end
    end
    
    describe :ping do
      it "should ping the connection" do
        @connection.should_receive(:ping)
        @client.ping
      end
    end

    describe :emit do
      it "should send the message to the connection with fansi enabled if char has it turned on" do
        char = double
        @client.char_id = 5
        @client.stub(:find_char) { char }
        char.stub(:fansi_on) { true }
        @connection.should_receive(:send_formatted).with("Hi", true)
        @client.emit "Hi"
      end
    end
        
    describe :emit do
      it "should send the message to the connection" do
        @connection.should_receive(:send_formatted).with("Hi", false)
        @client.emit "Hi"
      end
    end

    describe :emit_ooc do
      it "should send the message with yellow ansi tags and %% prefix" do
        @connection.should_receive(:send_formatted).with("%xc%% OOC%xn", false)
        @client.emit_ooc "OOC"
      end
    end    
    
    describe :emit_success do
      it "should send the message with green ansi tags and %% prefix" do
        @connection.should_receive(:send_formatted).with("%xg%% Yay%xn", false)
        @client.emit_success "Yay"
      end
    end

    describe :emit_failure do
      it "sends the message with green ansi tags and %% prefix" do
        @connection.should_receive(:send_formatted).with("%xr%% Boo%xn", false)
        @client.emit_failure "Boo"
      end
    end
    
    describe :emit_raw do
      it "sends the raw text without formatting and with a linebreak" do
        @connection.should_receive(:send_data).with("%xr%%Boo%xn%r\r\n")
        @client.emit_raw "%xr%%Boo%xn%r"
      end
    end
    
    describe :handle_input do
      before do 
        Global.logger.stub(:error) do |msg| 
          raise msg
        end
      end
      
      it "should create a command and notify the dispatcher" do
        cmd = double
        Command.should_receive(:new).with("Yay") { cmd }
        @dispatcher.should_receive(:queue_command).with(@client, cmd)
        @client.handle_input "Yay\n"        
      end
      
      it "should concatenate split commands" do
        cmd = double
        Command.should_receive(:new).with("Yay!More!") { cmd }
        @dispatcher.should_receive(:queue_command).with(@client, cmd)
        @client.handle_input "Yay!"        
        @client.handle_input "More!\n"
      end
      
      it "should ignore null input" do
        @dispatcher.should_not_receive(:queue_command)
        @client.handle_input nil
      end
      
      it "should ignore empty input" do
        @dispatcher.should_not_receive(:queue_command)
        @client.handle_input "\n"
        @client.handle_input "\r\n"
        @client.handle_input "\n\n"
        @client.handle_input "      "
      end
    end

    describe :disconnect do
      it "should close the connection and flush output" do
        @connection.should_receive(:close_connection).with(true)
        @client.disconnect
      end
    end
    
    describe :connection_closed do
      it "should notify the client monitor that the connection closed" do
        @client_monitor.should_receive(:connection_closed).with(@client)
        @client.connection_closed
      end
    end 
    
    describe :idle_secs do
      it "should track the time since last activity" do
        @client.last_activity = Time.parse("2011-1-2 10:59:01")
        fake_now = Time.parse("2011-1-2 11:00:00")
        Time.stub(:now) { fake_now }
        @client.idle_secs.should eq 59
      end
    end
    
    describe :connected_secs do
      it "should track the time since last connect" do
        @client.last_connect = Time.parse("2011-1-2 10:59:01")
        fake_now = Time.parse("2011-1-2 11:00:00")
        Time.stub(:now) { fake_now }
        @client.connected_secs.should eq 59
      end
    end
    
    describe :ip_addr do
      it "should return the IP of the connection" do
        @client.ip_addr.should eq "1.2.3.4"
      end
    end
    
    describe :hostname do
      it "should resolve the IP address" do
        @client.hostname.should eq "fake host"
      end
   end 
   
   describe :find_char do
     it "should look up the char if there is one" do
       @client.char_id = 15
       found_char = double
       Character.stub(:[]).with(15) { found_char }
       @client.find_char.should eq found_char
     end
     
     it "should return nil if not logged in" do
       @client.char_id = nil
       @client.find_char.should eq nil
     end
   end
  end
end