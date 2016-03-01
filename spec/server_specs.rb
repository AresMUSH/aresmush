$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Server do
    include GlobalTestHelper
    include GameTestHelper
    
    before do
      stub_global_objects
      stub_game_master
    end
    
    describe :start do
      before do
        Global.stub(:read_config).with("server", "hostname") { "host" }
        Global.stub(:read_config).with("server", "port") { 123 }
        Global.stub(:read_config).with("server", "websocket_port") { 234 }
        @server = Server.new
        dispatcher.stub(:queue_event)
        game.stub(:welcome_room) { nil }
        EventMachine::WebSocket.stub(:start).and_yield(double)
        EventMachine.stub(:run).and_yield
        EventMachine.stub(:add_periodic_timer)
        EventMachine.stub(:start_server)
      end
      
      it "should start a timer for the pings" do
        EventMachine.should_receive(:run).and_yield
        EventMachine.should_receive(:add_periodic_timer)
        @server.start
      end
      
      it "should start the event machine" do
        EventMachine.should_receive(:run)
        @server.start
      end

      it "should start the server" do
        EventMachine.should_receive(:run).and_yield
        EventMachine.should_receive(:start_server).with('host', 123, Connection)
        @server.start
      end

      it "should start the web server" do
        EventMachine::WebSocket.should_receive(:start).with({:host=>"host", :port=>234}).and_yield(double)
        EventMachine.stub(:add_periodic_timer)
        @server.start
      end
      
      describe "after server started" do
        before do
          @connection = double(Connection).as_null_object
          EventMachine.should_receive(:run).and_yield
          EventMachine.stub(:add_periodic_timer)
          EventMachine.should_receive(:start_server).and_yield(@connection)
          client_monitor.stub(:connection_established)
        end
        
        it "should queue the game started event" do
          event = double
          GameStartedEvent.stub(:new) { event }
          dispatcher.should_receive(:queue_event).with(event)
          @server.start
        end
      
        it "should notify the client monitor of new connections" do
          client_monitor.should_receive(:connection_established).with(@connection)
          @server.start
        end
      end    
    end
  end
end
