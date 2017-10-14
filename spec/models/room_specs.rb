$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe Room do
    
    before do
      @room = Room.new
      @client1 = double
      @client2 = double
      @client3 = double
      @char1 = double
      @char2 = double
      @char3 = double
      
      client_monitor = double
      @char1.stub(:room) { @room }
      @char2.stub(:room) { @room }
      @char3.stub(:room) { double }
    end
    
    describe :emit do
      it "should emit to all clients in the room" do
        @char1.stub(:is_online?) { true }
        @char2.stub(:is_online?) { true }
        @char3.stub(:is_online?) { false }
        @char1.stub(:client) { @client1 }
        @char2.stub(:client) { @client2 }
        @room.stub(:characters) { [ @char1, @char2, @char3 ]}
        @client1.should_receive(:emit).with("Test")
        @client2.should_receive(:emit).with("Test")
        @client3.should_not_receive(:emit)
        @room.emit("Test")        
      end
    end
    
    describe :get_exit do
      it "should return exit if exit exists - case-insensitive" do
        exit1 = Exit.new(:name_upcase => "A",)
        exit2 = Exit.new(:name_upcase => "B")
        @room.stub(:exits) { [ exit1, exit2 ]}
        @room.get_exit("a").name_upcase.should eq "A"
        @room.get_exit("B").name_upcase.should eq "B"
        @room.get_exit("C").should eq nil
      end
    end
    
    describe :way_out do 
      it "should return the exit with name 'O' if it exists" do
        ex = double
        @room.stub(:get_exit).with("O") { ex }
        @room.way_out.should eq ex
      end
      
      it "should return first exit if 'O' doesn't exist" do

        exit1 = Exit.new(:name_upcase => "A")
        exit2 = Exit.new(:name_upcase => "B")
        @room.stub(:exits) { [ exit1, exit2 ]}
        
        @room.way_out.name_upcase.should eq "A"
      end
    end
    
    
  end
end