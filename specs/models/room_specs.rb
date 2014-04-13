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
    
    describe :has_exit? do
      include SpecHelpers
      it "should return true if exit exists - case-insensitive" do
        using_test_db do
          exit = Exit.new(:name => "A")
          @room.exits << exit
          @room.save!
          @room.has_exit?("a").should be_true
        end
      end
      
      it "should return false if exit doesn't exist" do
        using_test_db do
          exit = Exit.new(:name => "A")
          @room.exits << exit
          @room.save!
          @room.has_exit?("b").should be_false
        end
      end
    end
    
    describe :set_upcase_name do
      it "should set the uppercase name on save" do
        using_test_db do
          @room.name = "test"
          @room.save!
          @room.name_upcase.should eq "TEST"
        end
      end
    end
    
    describe :find_by_name do
      it "should find by name upcase" do
        using_test_db do
          @room.name = "test"
          @room.save!
          Room.find_by_name("TeSt").should eq @room
        end
      end
    end
    
    describe :find_all_by_name do
      it "should find many by name upcase" do
        using_test_db do
          @room.name = "test"
          @room.save!
          
          room2 = Room.create(name: "test")
          
          Room.find_all_by_name("TeSt").should eq [ @room, room2 ]
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