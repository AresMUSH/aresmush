module AresMUSH
  module Rooms
    describe Rooms do
      describe :open_exit do
        before do
          @source = double
          @dest = double
          allow(@source).to receive(:name) { "source" }
          allow(@dest).to receive(:name) { "dest" }
          stub_translate_for_testing
        end
      
        it "should return error if exit already exists." do
          expect(@source).to receive(:has_exit?).with("AE") { true }
          expect(Exit).to_not receive(:create)
          expect(Rooms.open_exit("AE", @source, @dest)).to eq "rooms.exit_already_exists"
        end
      
        it "should create the exit" do
          allow(@source).to receive(:has_exit?) { false }
          expect(Exit).to receive(:create).with( { :name => "AE", :source => @source, :dest => @dest } )
          expect(Rooms.open_exit("AE", @source, @dest)).to eq "rooms.exit_created"
        end
      end
    

      describe :find_destination do
        before do
          @room = double
          allow(@room).to receive(:name_upcase) { "SOMEWHERE" }
          @rooms = [ @room ]
          @enactor = double
          allow(Room).to receive(:all) { @rooms }
        end
        
        it "should find the room when the destination is a char" do
          other_char = double
          allow(other_char).to receive(:room) { @room }
          expect(ClassTargetFinder).to receive(:find).with("somewhere", Character, @enactor) { FindResult.new(other_char, nil) }
          expect(Rooms.find_destination("somewhere", @enactor, true)).to eq [@room]
        end
        
        it "should find the room when the destination is a room with an exact name match" do
          expect(ClassTargetFinder).to receive(:find).with("somewhere", Character, @enactor) { FindResult.new(nil, "error") }
          expect(ClassTargetFinder).to receive(:find).with("somewhere", Room, @enactor) { FindResult.new(@room, nil) }
          expect(Rooms.find_destination("somewhere", @enactor, true)).to eq [@room]
        end
      end
      
      describe :emit_here_desc do
        it "should emit current room desc" do
          client = double
          char = double
          room = double
          template = double
          expect(Describe).to receive(:desc_template).with(room, char) { template }
          expect(template).to receive(:render) { "room desc" }
          allow(char).to receive(:room) { room }
          expect(client).to receive(:emit).with("room desc")
          Rooms.emit_here_desc(client, char)
        end
      end   
    end   
  end
end
