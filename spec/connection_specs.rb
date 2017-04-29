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
        @connection.client = @client
      end
      
      it "should send data to the client" do
        @client.should_receive(:handle_input).with("test")
        @connection.receive_data("test")        
      end
      
      it "should strip null control codes" do
        @client.should_receive(:handle_input).with("test")
        @connection.receive_data("test^@\0")    
      end
      
      it "should strip out a telnet NAW2S at the beginning" do
        @client.should_receive(:handle_input).with("012")
        data = [ 255, 251, 31, 0x30, 0x31, 0x32 ]
        str = data.map { |d| d.chr }.join
        @connection.receive_data(str)
      end
      
      it "should strip out a telnet NAWS at the beginning" do
        @client.should_receive(:handle_input).with("012")
        data = [ 255, 250, 31, 0, 80, 0, 24, 255, 240, 0x30, 0x31, 0x32 ]
        str = data.map { |d| d.chr }.join
        @connection.receive_data(str)
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