$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Room, :dbtest => true do
    
    before do
      @room = Room.new
      @client1 = double
      @client2 = double
      @client3 = double
      @char1 = double
      @char2 = double
      @char3 = double
      
      client_monitor = double
      Global.stub(:client_monitor) { client_monitor }
      client_monitor.stub(:logged_in) { { @client1 => @char1, @client2 => @char2, @client3 => @char3 } }
      @char1.stub(:room) { @room }
      @char2.stub(:room) { @room }
      @char3.stub(:room) { double }
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
    
    describe :get_exit do
      it "should return exit if exit exists - case-insensitive" do
        exit1 = Exit.new(:name_upcase => "A",)
        exit2 = Exit.new(:name_upcase => "B")
        @room.stub(:exits) { [ exit1, exit2 ]}
        @room.get_exit("a").should eq exit1
        @room.get_exit("B").should eq exit2
        @room.get_exit("C").should eq nil
      end
    end
    
    describe :way_out do 
      it "should return the exit with name 'O' if it exists" do
        exit = double
        @room.stub(:get_exit).with("O") { exit }
        @room.way_out.should eq exit
      end
      
      it "should return first exit if 'O' doesn't exist" do
        exit1 = Exit.new(:name => "A")
        exit2 = Exit.new(:name => "B")
        @room.stub(:exits) { [ exit1, exit2 ]}
        @room.way_out.should eq exit1
      end
    end
    
    describe :delete do
      it "should delete all exits leading into and out of the room" do
        using_test_db do
          room = Room.create
          leading_out = Exit.create(:source => room)
          leading_in = Exit.create(:dest => room)
          room.delete
          Exit.find(leading_out.id).should be_nil
          exit = Exit.find(leading_in.id)
          exit.dest.should be_nil
        end
      end
    end
    
  end
end