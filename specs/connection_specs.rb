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
        ClientFormatter.should_receive(:format).with("test") { "TEST" }
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
      
      it "should strip null control codes" do
        client = double
        @connection.client = client
        client.should_receive(:handle_input).with("test")
        @connection.receive_data("test^@")    
      end
      
      it "should convert control code newline to newline" do
        client = double
        @connection.client = client
        client.should_receive(:handle_input).with("test\n")
        @connection.receive_data("test^M")    
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