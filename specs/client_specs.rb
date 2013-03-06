$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "ansi"

module AresMUSH

  describe Client do

    before do
      AresMUSH::Locale.stub(:translate).with("client.welcome") { "welcome" }
      AresMUSH::Locale.stub(:translate).with("client.anonymous") { "anon" }
      AresMUSH::Locale.stub(:translate).with("client.goodbye") { "bye" }
    end

    describe :connected do
      before do
        config_reader = double(ConfigReader)
        config_reader.stub(:config) { { 'connect' => { 'welcome_text' => "Hi", 'welcome_screen' => "Ascii Art" } } }
        @connection = double(EventMachine::Connection).as_null_object
        @client = Client.new(1, nil, config_reader, @connection)
      end

      it "sends the welcome screen" do
        @connection.should_receive(:send_data).with("Ascii Art")
        @client.connected
      end

      it "sends the game welcome text" do
        @connection.should_receive(:send_data).with("Hi")
        @client.connected
      end

      it "sends the server welcome text" do
        @connection.should_receive(:send_data).with("%xc%% welcome%xn")
        @client.connected
      end

    end

    describe :disconnected do
      it "should send the bye text" do
        connection = double(EventMachine::Connection).as_null_object
        client = Client.new(1, nil, nil, connection)
        connection.should_receive(:send_data).with("%xc%% bye%xn")
        client.disconnected
      end
    end
    
    describe :emit do
      before do
        @connection = double(EventMachine::Connection)
        @client = Client.new(1, nil, nil, @connection)
      end

      it "sends the message to the connection" do
        @connection.should_receive(:send_data).with("Hi")
        @client.emit "Hi"
      end
    end

    describe :emit_ooc do
      it "sends the message with yellow ansi tags and %% prefix" do
        @connection = double(EventMachine::Connection)
        @client = Client.new(1, nil, nil, @connection)
        @connection.should_receive(:send_data).with("%xc%% OOC%xn")
        @client.emit_ooc "OOC"
      end
    end
    
    describe :emit_with_lines do
      it "sends the message between the lines" do
          config_reader = double(ConfigReader)
          config_reader.stub(:line) { "---" }
          @connection = double(EventMachine::Connection).as_null_object
          @client = Client.new(1, nil, config_reader, @connection)
          @connection.should_receive(:send_data).with("---\ntest\n---")
          @client.emit_with_lines "test"
      end
    end

    describe :emit_success do
      it "sends the message with green ansi tags and %% prefix" do
        @connection = double(EventMachine::Connection)
        @client = Client.new(1, nil, nil, @connection)
        @connection.should_receive(:send_data).with("%xg%% Yay%xn")
        @client.emit_success "Yay"
      end
    end

    describe :emit_failure do
      it "sends the message with green ansi tags and %% prefix" do
        @connection = double(EventMachine::Connection)
        @client = Client.new(1, nil, nil, @connection)
        @connection.should_receive(:send_data).with("%xr%% Boo%xn")
        @client.emit_failure "Boo"
      end
    end

    describe :handle_input do
      it "should pass the input along to the client monitor" do
        client_monitor = double(ClientMonitor)
        client = Client.new(1, client_monitor, nil, nil)
        client_monitor.should_receive(:handle_client_input).with(client, "Yay")
        client.handle_input "Yay"
      end
    end

    describe :disconnect do
      it "should close the connection" do
        @connection = double(EventMachine::Connection)
        @client = Client.new(1, nil, nil, @connection)
        @connection.should_receive(:close_connection)
        @client.disconnect
      end
    end

    describe :connection_closed do
      it "should notify the client monitor that the connection closed" do
        client_monitor = double(ClientMonitor)
        client = Client.new(1, client_monitor, nil, nil)
        client_monitor.should_receive(:connection_closed).with(client)
        client.connection_closed
      end
    end 
    
    describe :name do
      it "should use the player name if available" do
        client = Client.new(1, nil, nil, nil)
        client.player = { "name" => "Bob" }
        client.name.should eq "Bob"
      end
      
      it "should use anonymous if there's no player" do
        client = Client.new(1, nil, nil, nil)
        client.name.should eq "anon"
      end
      
    end
    
    describe :location do
      it "should use the player location if available" do
        client = Client.new(1, nil, nil, nil)
        client.player = { "location" => "111" }
        client.location.should eq "111"
      end
      
      it "should use nil if there's no player" do
        client = Client.new(1, nil, nil, nil)
        client.location.should eq nil
      end
      
    end
     
  end
end