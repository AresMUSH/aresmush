$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "ansi"

module AresMUSH

  describe Client do

    before do
      AresMUSH::Locale.stub(:translate).with("welcome") { "welcome" }
    end

    describe :connected do
      before do
        config_reader = double(ConfigReader)
        config_reader.stub(:config) { { 'connect' => { 'welcome_text' => "Hi" } } }
        config_reader.stub(:txt) { { 'connect' => "Ascii Art"} }
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
     
  end
end