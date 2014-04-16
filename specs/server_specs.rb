$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Server do
    include GlobalTestHelper
    
    before do
      stub_global_objects
    end
    
    describe :start do
      before do
        Global.stub(:config) { {'server' => { 'hostname' => 'host', 'port' => 123 }} }
        @server = Server.new
      end
      
      it "should start a timer for the pings" do
        EventMachine.should_receive(:run).and_yield
        EventMachine.should_receive(:add_periodic_timer)
        EventMachine.stub(:start_server)
        @server.start
      end
      
      it "should start the event machine" do
        EventMachine.should_receive(:run)
        @server.start
      end
      
      it "should start the server" do
        EventMachine.should_receive(:run).and_yield
        EventMachine.stub(:add_periodic_timer)
        EventMachine.should_receive(:start_server).with('host', 123, Connection)
        @server.start
      end
      
      it "should notify the client monitor of new connections" do
        connection = double(Connection).as_null_object
        EventMachine.should_receive(:run).and_yield
        EventMachine.stub(:add_periodic_timer)
        EventMachine.should_receive(:start_server).and_yield(connection)
        client_monitor.should_receive(:connection_established).with(connection)
        @server.start
      end      
    end    
  end
end