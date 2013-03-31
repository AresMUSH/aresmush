$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Connection do

    describe :format_msg do
      it "adds a \n to the end if not already there" do
        msg = Connection.format_msg("msg")
        msg.should eq "msg\n" + ANSI.reset
      end

      it "doesn't add another \n if there's already one on the end" do
        msg = Connection.format_msg("msg\n")
        msg.should eq "msg\n" + ANSI.reset
      end

      it "expands ansi codes" do
        msg = Connection.format_msg("my %xcansi%xn message\n")
        msg.should eq "my " + ANSI.cyan + "ansi" + ANSI.reset + " message\n" + ANSI.reset
      end
    end
    
    describe :ping do
      it "should send a null char" do
        connection = Connection.new(nil)
        connection.should_receive(:send_data).with("\0")
        connection.ping
      end
    end
    
    describe :send do
      it "should format the message before sending" do
        connection = Connection.new(nil)
        connection.should_receive(:send_data).with("TEST")
        Connection.should_receive(:format_msg).with("test") { "TEST" }
        connection.send_formatted("test")
      end
    end
    
    describe :receive_data do
      it "should send data to the client" do
        client = mock
        connection = Connection.new(nil)
        connection.client = client
        client.should_receive(:handle_input).with("test")
        connection.receive_data("test")        
      end
    end
    
    describe :unbind do
      it "should notify the client that it disconnected" do
        client = mock
        connection = Connection.new(nil)
        connection.client = client
        client.should_receive(:connection_closed)
        connection.unbind
      end
    end
  end
end