$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Connection do

    before do
      @connection = Connection.new(nil)
    end
      
    describe :ping do
      it "should send a null char" do
        @connection.should_receive(:send_data).with("\0")
        @connection.ping
      end
    end
    
    describe :send_formatted do
      it "should format the message before sending" do
        config_reader = double
        @connection.config_reader = config_reader
        ClientFormatter.should_receive(:format).with("test", config_reader) { "TEST" }
        @connection.should_receive(:send_data).with("TEST")
        @connection.send_formatted("test")
      end
    end    
    
    describe :receive_data do
      it "should send data to the client" do
        client = double
        @connection.client = client
        client.should_receive(:handle_input).with("test")
        @connection.receive_data("test")        
      end
    end
    
    describe :unbind do
      it "should notify the client that it disconnected" do
        client = double
        @connection.client = client
        client.should_receive(:connection_closed)
        @connection.unbind
      end
    end
  end
end