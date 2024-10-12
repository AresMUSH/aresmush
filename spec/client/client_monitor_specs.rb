

require "aresmush"

module AresMUSH

  describe ClientMonitor do
    include GlobalTestHelper
   
    before do
      stub_global_objects
      
      @factory = double(ClientFactory).as_null_object
      @client_monitor = ClientMonitor.new(@factory)

      # Set up a couple of test clients
      @client1 = double(Client).as_null_object
      @client2 = double(Client).as_null_object
      @client_monitor.clients << @client1
      @client_monitor.clients << @client2
    end
    
    describe :emit_all do
      it "should notify all the clients" do
        expect(@client1).to receive(:emit).with("Hi")
        expect(@client2).to receive(:emit).with("Hi")
        @client_monitor.emit_all "Hi"
      end
    end
    
    describe :emit_all_ooc do
      it "should emit ooc to all the clients" do
        expect(@client1).to receive(:emit_ooc).with("Hi")
        expect(@client2).to receive(:emit_ooc).with("Hi")
        @client_monitor.emit_all_ooc "Hi" 
      end
    end
    
    describe :emit do
      it "should notify all the clients matching the specified trigger block" do
        expect(@client1).to_not receive(:emit)
        expect(@client2).to receive(:emit).with("Hi")
        @client_monitor.emit "Hi" do |c|
          c == @client2
        end
      end
    end
    
    describe :emit_ooc do
      it "should emit ooc to all the clients matching the specified trigger block" do
        expect(@client1).to receive(:emit_ooc).with("Hi")
        expect(@client2).to_not receive(:emit_ooc)
        @client_monitor.emit_ooc "Hi" do |c|
          c == @client1
        end
      end
    end    

    describe :connection_closed do
      it "should remove the client from the list" do
        allow(dispatcher).to receive(:queue_event)
        @client_monitor.connection_closed(@client1)
        expect(@client_monitor.clients).to eq [@client2]
      end
      
      it "should notify the dispatcher of an anonymous client disconnected" do
        allow(@client1).to receive(:logged_in?) { false }
        expect(dispatcher).to receive(:queue_event) do |event|
          expect(event.class).to eq ConnectionClosedEvent
          expect(event.client).to eq @client1
        end
        @client_monitor.connection_closed(@client1)
      end

      it "should notify the dispatcher of a client disconnected with a char logged in" do
        allow(@client1).to receive(:logged_in?) { true }
        expect(dispatcher).to receive(:queue_event) do |event|
          expect(event.class).to eq ConnectionClosedEvent
          expect(event.client).to eq @client1
        end
        expect(dispatcher).to receive(:queue_event) do |event|
          expect(event.class).to eq CharDisconnectedEvent
          expect(event.client).to eq @client1
        end
        @client_monitor.connection_closed(@client1)
      end
    end
    
    describe :connection_established do
      before do
        @client3 = double(Client).as_null_object
        @connection = double(Connection).as_null_object
      end

      it "should create a client" do
        expect(@factory).to receive(:create_client).with(@connection) { @client3 }
        @client_monitor.connection_established(@connection)
      end

      it "should add the client to the list" do
        allow(@factory).to receive(:create_client) { @client3 }
        @client_monitor.connection_established(@connection)
        expect(@client_monitor.clients).to include @client3
      end

      it "should tell the client it has connected" do
        allow(@factory).to receive(:create_client) { @client3 }
        expect(@client3).to receive(:connected)
        @client_monitor.connection_established(@connection)
      end
      
      it "should notify the dispatcher" do
        allow(@factory).to receive(:create_client) { @client3 }
        expect(dispatcher).to receive(:queue_event) do |event|
          expect(event.class).to eq ConnectionEstablishedEvent
          expect(event.client).to eq @client3
        end
        expect(Global.logger).to_not receive(:debug)
        @client_monitor.connection_established(@connection)
      end
    end
    
    describe :logged_in_clients do
      it "should count logged in people" do
        client3 = double
        allow(@client1).to receive(:logged_in?) { false }
        allow(@client2).to receive(:logged_in?) { true }
        allow(client3).to receive(:logged_in?) { true }
        @client_monitor.clients << client3
        expect(@client_monitor.logged_in_clients).to eq [@client2, client3]
      end
    end
    
    describe :find_client do
      it "should find a client with a matching character" do
        char = double
        allow(char).to receive(:id) { 123 }
        allow(@client1).to receive(:char_id) { 123 }
        expect(@client_monitor.find_client(char)).to eq @client1
      end
      
      it "should return nil if no client found" do
        char = double
        allow(char).to receive(:id) { 123 }
        allow(@client1).to receive(:char_id) { 456 }
        expect(@client_monitor.find_client(char)).to eq nil
      end
    end
  end
end
