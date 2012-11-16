$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ClientMonitor do

    before do
      @config_reader = double(ConfigReader)
      @dispatcher = double(Dispatcher).as_null_object
      @client_monitor = ClientMonitor.new(@config_reader, @dispatcher)
      setup_a_couple_clients
    end

    describe :tell_all do
      it "should notify all the clients" do
        @client1.should_receive(:emit).with("Hi")
        @client2.should_receive(:emit).with("Hi")
        @client_monitor.tell_all "Hi"
      end
    end

    describe :connection_closed do
      it "should remove the client from the list" do
        @client_monitor.connection_closed(@client1)
        @client_monitor.clients.should eq [@client2]
      end
      
      it "should notify the dispatcher" do
        @dispatcher.should_receive(:on_event) do |type, args|
          type.should eq :player_disconnected
          args[:client].should eq @client1
        end
        @client_monitor.connection_closed(@client1)
      end
    end
    
    describe :handle_client_input do
      it "should notify the dispatcher" do
        @dispatcher.should_receive(:on_command).with(@client1, kind_of(Command)) do |client, cmd|
          cmd.raw.should eq "test"
        end
        @client_monitor.handle_client_input(@client1, "test")
      end
    end

    describe :connection_established do
      before do
        @client3 = double(Client).as_null_object
        @connection = double(Connection).as_null_object
      end

      it "creates a client" do
        Client.should_receive(:new).with(anything, @client_monitor, @config_reader, @connection) { @client3 }
        @client_monitor.connection_established(@connection)
      end

      it "increments the next client id" do
        Client.should_receive(:new).with(anything, @client_monitor, @config_reader, @connection) { @client3 }
        @client_monitor.connection_established(@connection)
        @client_monitor.client_id.should eq 1
      end

      it "assigns the client the next id" do
        Client.should_receive(:new).with(1, @client_monitor, @config_reader, @connection) { @client3 }
        @client_monitor.connection_established(@connection)
      end 

      it "tells the connection what its client is" do
        Client.should_receive(:new) { @client3 }
        @connection.should_receive(:client=).with(@client3)
        @client_monitor.connection_established(@connection)
      end

      it "adds the client to the list" do
        Client.should_receive(:new) { @client3 }
        @client_monitor.connection_established(@connection)
        @client_monitor.clients.should include @client3
      end

      it "tells the client it has connected" do
        Client.should_receive(:new) { @client3 }
        @client3.should_receive(:connected)
        @client_monitor.connection_established(@connection)
      end

      it "should notify the dispatcher" do
        Client.should_receive(:new).with(anything, @client_monitor, @config_reader, @connection) { @client3 }
        @dispatcher.should_receive(:on_event) do |type, args|
          type.should eq :player_connected
          args[:client].should eq @client3
        end
        @client_monitor.connection_established(@connection)
      end
    end

    def setup_a_couple_clients
      @client1 = double(Client).as_null_object
      @client2 = double(Client).as_null_object
      @client_monitor.clients << @client1
      @client_monitor.clients << @client2
    end
  end
end