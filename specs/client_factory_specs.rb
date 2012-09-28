$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ClientFactory, "#new_client" do

    before do
      @session = double(TCPSocket)
      @factory = ClientFactory.new
    end
    
    def make_stub_client(id)
      client = double(Client)
      Client.should_receive(:new).with(id, @session) { client}
      client
    end
    
    it "creates a new client" do
      client = make_stub_client(1)
      @factory.new_client(@session).should eq client
    end

    it "increments the id of each new client" do
      client1 = make_stub_client(1)
      client2 = make_stub_client(2)

      @factory.new_client(@session).should eq client1
      @factory.new_client(@session).should eq client2
    end

  end
end