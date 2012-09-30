$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "ansi"

module AresMUSH

  describe Client do

    describe :format_msg do
      before do
        @client = Client.new(1, nil, nil, nil)
      end
      
      it "adds a \n to the end if not already there" do
        msg = @client.format_msg("msg")
        msg.should eq "msg\n"
      end

      it "doesn't add another \n if there's already one on the end" do
        msg = @client.format_msg("msg\n")
        msg.should eq "msg\n"
      end

      it "expands ansi codes" do
        msg = @client.format_msg("my %xcansi%xn message\n")
        msg.should eq "my " + ANSI.cyan + "ansi" + ANSI.reset + " message\n"
      end
    end
    
    describe :connected do
      before do
        config_reader = double(ConfigReader)
        config_reader.stub(:config) { { 'connect' => { 'welcome_text' => "Hi" } } }
        config_reader.stub(:txt) { { 'connect' => "Ascii Art"} }
        @connection = double(EventMachine::Connection)
        @client = Client.new(1, nil, config_reader, @connection)
      end
      
      it "sends the welcome screen and welcome message" do
        @connection.should_receive(:send_data).with("Ascii Art\n")
        @connection.should_receive(:send_data).with("Hi\n")
        @client.connected
      end
     
    end
    
    describe :emit do
      before do
        @connection = double(EventMachine::Connection)
        @client = Client.new(1, nil, nil, @connection)
      end
      
      it "sends the message to the connection" do
        @connection.should_receive(:send_data).with("Hi\n")
        @client.emit "Hi"
      end

      it "formats the message" do
        @connection.should_receive(:send_data).with(ANSI.cyan + "Hi" + ANSI.reset + "\n")
        @client.emit "%xcHi%xn"
      end
     
    end
    
    describe :handle_input do
      # TODO - pass on to command modules
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