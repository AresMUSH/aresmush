$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Client do

    describe :ip do
      it "returns the session's IP address" do
        session = double(TCPSocket)
        client = Client.new(1, session)
        session.stub(:addr) { [0, 0, 0, "1.2.3.4"] }
        client.ip.should eq "1.2.3.4"
      end
    end

    describe :host do
      it "returns the session's host address" do
        session = double(TCPSocket)
        client = Client.new(1, session)
        session.stub(:addr) { [0, 0, "hostname", 0] }
        client.host.should eq "hostname"
      end
    end
    
    describe :emit do
      it "sends the string to the session" do
        session = double(TCPSocket)
        client = Client.new(1, session)
        session.should_receive(:puts).with("hello")
        client.emit("hello")
      end
    end

  end
end