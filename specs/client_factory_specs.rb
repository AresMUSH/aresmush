$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ClientFactory do

    before do
      @factory = ClientFactory.new
      @connection = mock.as_null_object
      @container = mock.as_null_object
      @factory.container = @container
    end
      
    it "should initialize and return a client" do
      client = mock
      config_reader = mock
      client_monitor = mock
      @container.stub(:config_reader) { config_reader }
      @container.stub(:client_monitor) { client_monitor }
      Client.should_receive(:new).with(1, client_monitor, config_reader, @connection) { client }
      @factory.create_client(@connection).should eq client
    end
    
    it "should create clients with incremental ids" do
      client1 = @factory.create_client(@connection)
      client2 = @factory.create_client(@connection)
      client1.id.should eq 1
      client2.id.should eq 2
    end 

    it "should tell the connection what its client is" do
      client = mock
      Client.stub(:new) { client }
      @connection.should_receive(:client=).with(client)
      @factory.create_client(@connection)
    end

  end
end

