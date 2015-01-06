module AresMUSH

  describe Room, :dbtest => true do
    include GlobalTestHelper
    
    before do
      @room = Room.new
      @client1 = double
      @client2 = double
      @client3 = double
      stub_global_objects
      client_monitor.stub(:logged_in_clients) { [ @client1, @client2, @client3 ] }
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
    
    describe :get_exit? do
      include SpecHelpers
      it "should return exit if exit exists - case-insensitive" do
        using_test_db do
          exit = Exit.new(:name => "A")
          @room.exits << exit
          @room.save!
          @room.get_exit("a").should eq exit
        end
      end
      
      it "should return nil if exit doesn't exist" do
        using_test_db do
          exit = Exit.new(:name => "A")
          @room.exits << exit
          @room.save!
          @room.get_exit("b").should be_nil
        end
      end
      
      it "should match the out exit if one exists" do
        using_test_db do
          exit1 = Exit.new(:name => "A")
          exit2 = Exit.new(:name => "O")
          @room.exits << exit1
          @room.exits << exit2
          @room.save!
          @room.get_exit("O").should eq exit2
        end
      end
      
    end
    
    describe :has_exit? do
      it "should return false if get_exit is nil" do
        @room.stub(:get_exit).with("a") { nil }
        @room.has_exit?("a").should be_false
      end

      it "should return false if get_exit is not nil" do
        @room.stub(:get_exit).with("a") { double }
        @room.has_exit?("a").should be_true
      end
    end
    
    describe :way_out do 
      it "should return the exit with name 'O' if it exists" do
        exit = double
        @room.stub(:get_exit).with("O") { exit }
        @room.way_out.should eq exit
      end
      
      it "should return first exit if 'O' doesn't exist" do
        using_test_db do
          exit1 = Exit.new(:name => "A")
          exit2 = Exit.new(:name => "B")
          @room.exits << exit1
          @room.exits << exit2
          @room.save!
          @room.way_out.should eq exit1
        end
      end
    end
    
    describe :destroy do
      it "should delete all exits leading out of the room" do
        using_test_db do
          room = Room.create
          leading_out = Exit.create(:source => room)
          room.destroy
          Exit.find(leading_out.id).should be_nil
        end
      end
      
      it "should null all exits leading into the room" do
        using_test_db do
          room = Room.create
          leading_in = Exit.create(:dest => room)
          room.destroy
          exit = Exit.find(leading_in.id)
          exit.dest.should be_nil
        end
      end
    end
    
  end
end