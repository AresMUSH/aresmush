$:.unshift File.join(File.dirname(__FILE__), *%w[.. .. engine])

require "aresmush"

module AresMUSH

  describe ClientFactory do

    before do
      @factory = ClientFactory.new
      @connection = double.as_null_object
      allow(Resolv).to receive(:getname) { "fakehost" }
    end
      
    it "should initialize and return a client" do
      client = double
      expect(Client).to receive(:new).with(1, @connection) { client }
      expect(@factory.create_client(@connection)).to eq client
    end
    
    it "should create clients with incremental ids" do
      client1 = @factory.create_client(@connection)
      client2 = @factory.create_client(@connection)
      expect(client1.id).to eq 1
      expect(client2.id).to eq 2
    end 

    it "should tell the connection what its client is" do
      client = double
      allow(Client).to receive(:new) { client }
      expect(@connection).to receive(:connect_client).with(client)
      @factory.create_client(@connection)
    end

  end
end

