$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ClientMonitor do

    before do
      @config_reader = double(ConfigReader)
      @dispatcher = double(Dispatcher).as_null_object
      @factory = double(ClientFactory).as_null_object
      @client_monitor = ClientMonitor.new(@config_reader, @dispatcher, @factory)

      # Set up a couple of test clients
      @client1 = double(Client).as_null_object
      @client2 = double(Client).as_null_object
      @client_monitor.clients << @client1
      @client_monitor.clients << @client2
    end
    
    describe :emit_all do
      it "should notify all the clients" do
        @client1.should_receive(:emit).with("Hi")
        @client2.should_receive(:emit).with("Hi")
        @client_monitor.emit_all "Hi"
      end
    end

    describe :connection_closed do
      it "should remove the client from the list" do
        @client_monitor.connection_closed(@client1)
        @client_monitor.clients.should eq [@client2]
      end
      
      it "should notify the dispatcher" do
        @dispatcher.should_receive(:on_event) do |type, args|
          type.should eq :char_disconnected
          args[:client].should eq @client1
        end
        @client_monitor.connection_closed(@client1)
      end
    end
    
    describe :handle_client_input do
      it "should notify the dispatcher" do
        cmd = double
        Command.should_receive(:new).with(@client1, "test") { cmd }
        @dispatcher.should_receive(:on_command).with(@client1, cmd)
        @client_monitor.handle_client_input(@client1, "test")
      end
    end

    describe :connection_established do
      before do
        @client3 = double(Client).as_null_object
        @connection = double(Connection).as_null_object
      end

      it "should create a client" do
        @factory.should_receive(:create_client).with(@connection, @client_monitor) { @client3 }
        @client_monitor.connection_established(@connection)
      end

      it "should add the client to the list" do
        @factory.stub(:create_client) { @client3 }
        @client_monitor.connection_established(@connection)
        @client_monitor.clients.should include @client3
      end

      it "should tell the client it has connected" do
        @factory.stub(:create_client) { @client3 }
        @client3.should_receive(:connected)
        @client_monitor.connection_established(@connection)
      end

      it "should notify the dispatcher" do
        @factory.stub(:create_client) { @client3 }
        @dispatcher.should_receive(:on_event) do |type, args|
          type.should eq :connection_established
          args[:client].should eq @client3
        end
        @client_monitor.connection_established(@connection)
      end
    end
  end
end