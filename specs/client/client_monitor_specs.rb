$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

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
        @client1.should_receive(:emit).with("Hi")
        @client2.should_receive(:emit).with("Hi")
        @client_monitor.emit_all "Hi"
      end
    end
    
    describe :emit_all_ooc do
      it "should emit ooc to all the clients" do
        @client1.should_receive(:emit_ooc).with("Hi")
        @client2.should_receive(:emit_ooc).with("Hi")
        @client_monitor.emit_all_ooc "Hi"
      end
    end

    describe :connection_closed do
      it "should remove the client from the list" do
        dispatcher.stub(:on_event)
        @client_monitor.connection_closed(@client1)
        @client_monitor.clients.should eq [@client2]
      end
      
      it "should notify the dispatcher" do
        dispatcher.should_receive(:on_event) do |type, args|
          type.should eq :char_disconnected
          args[:client].should eq @client1
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
        @factory.should_receive(:create_client).with(@connection) { @client3 }
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
        dispatcher.should_receive(:on_event) do |type, args|
          type.should eq :connection_established
          args[:client].should eq @client3
        end
        Global.logger.should_not_receive(:debug)
        @client_monitor.connection_established(@connection)
      end
    end
    
    describe :logged_in_clients do
      it "should count logged in people" do
        client3 = double
        @client1.stub(:logged_in?) { false }
        @client2.stub(:logged_in?) { true }
        client3.stub(:logged_in?) { true }
        @client_monitor.clients << client3
        @client_monitor.logged_in_clients.should eq [@client2, client3]
      end
    end
    
    describe :find_client do
      it "should find a client with a matching character" do
        char = double
        @client1.stub(:char) { char }
        @client_monitor.find_client(char).should eq @client1
      end
      
      it "should return nil if no client found" do
        char = double
        @client_monitor.find_client(char).should eq nil
      end
    end
    
    describe :reload_clients do
      before do
        @char = double
        @client1.stub(:char) { nil }
        @client2.stub(:char) { @char }
      end
      
      it "should trigger a reload on a logged-in client" do
        @char.should_receive(:reload)
        @client_monitor.reload_clients
      end
      
      it "should do nothing if the client is not logged in" do
        @char.stub(:reload)
        @client_monitor.reload_clients
      end
    end
  end
end