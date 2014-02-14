$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Room do
    
    before do
      @room = Room.new
      @client1 = double
      @client2 = double
      @client3 = double
      @client_monitor = double
      Global.stub(:client_monitor) { @client_monitor }
      @client_monitor.stub(:logged_in_clients) { [ @client1, @client2, @client3 ] }
      @client1.stub(:room) { @room }
      @client2.stub(:room) { @room }
      @client3.stub(:room) { double }
    end
    
    describe :clients do
      it "should find clients whose chars are in this room" do
        @room.clients.should eq [ @client1, @client2 ]
      end
    end
    
    describe :emit do
      it "should emit to all clients in the room" do
        @client1.should_receive(:emit).with("Test")
        @client2.should_receive(:emit).with("Test")
        @client3.should_not_receive(:emit)
        @room.emit("Test")        
      end
    end
    
    describe :emit_ooc do
      it "should emit to all clients in the room" do
        @client1.should_receive(:emit_ooc).with("Test")
        @client2.should_receive(:emit_ooc).with("Test")
        @client3.should_not_receive(:emit_ooc)
        @room.emit_ooc("Test")        
      end
    end    
      
      
  end
end