$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe ClientFactory do

    before do
      @factory = ClientFactory.new
      @connection = double.as_null_object
      Resolv.stub(:getname) { "fakehost" }
    end
      
    it "should initialize and return a client" do
      client = double
      Client.should_receive(:new).with(1, @connection) { client }
      @factory.create_client(@connection).should eq client
    end
    
    it "should create clients with incremental ids" do
      client1 = @factory.create_client(@connection)
      client2 = @factory.create_client(@connection)
      client1.id.should eq 1
      client2.id.should eq 2
    end 

    it "should tell the connection what its client is" do
      client = double
      Client.stub(:new) { client }
      @connection.should_receive(:connect_client).with(client)
      @factory.create_client(@connection)
    end

  end
end

