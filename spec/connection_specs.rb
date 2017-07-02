$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Connection do

    before do
      @connection = Connection.new(nil)
    end
      
    describe :ping do
      it "should send an empty string" do
        @connection.should_receive(:send_data).with("\e[0m")
        @connection.ping
      end
    end
    
    describe :send_formatted do
      it "should format the message before sending" do
        ClientFormatter.should_receive(:format).with("test", true) { "TEST" }
        @connection.should_receive(:send_data).with("TEST")
        @connection.send_formatted("test")
      end
    end    
    
    describe :receive_data do
      before do
        @client = double
        @client.stub(:id) { 1 }
        @connection.connect_client @client
        negotiator = double
        @connection.negotiator = negotiator
        negotiator.stub(:handle_input) do |data|
          data
        end
      end
      
      it "should send data to the client" do
        @client.should_receive(:handle_input).with("test")
        @connection.receive_data("test")        
      end
      
      it "should strip null control codes" do
        @client.should_receive(:handle_input).with("test")
        @connection.receive_data("test^@\0")
      end
      
      it "should handle multiple commands" do
        @client.should_receive(:handle_input).with("test1\n")
        @client.should_receive(:handle_input).with("test2\n")
        @connection.receive_data("test1\ntest2")
      end
      
      it "should convert control code newline to newline" do
        @client.should_receive(:handle_input).with("test\n")
        @connection.receive_data("test^M")    
      end
    end
    
    describe :unbind do
      it "should notify the client that it disconnected" do
        client = double
        client.stub(:id) { 1 }
        @connection.connect_client client
        client.should_receive(:connection_closed)
        @connection.unbind
      end
    end
  end
end