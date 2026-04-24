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
      
      describe :has_parent_area do
        before do
          @a1 = double
          @a2 = double
          @a3 = double
          @a4 = double
          allow(@a1).to receive(:name) { "A1" }
          allow(@a2).to receive(:name) { "A2" }
          allow(@a3).to receive(:name) { "A3" }
          allow(@a4).to receive(:name) { "A4" }
        end

        it "should return false if no connections" do
          allow(@a2).to receive(:parent) { nil }
          expect(Rooms.has_parent_area(@a2, @a1)).to eq false
        end
        
        it "should return true if parenting to your own child" do
          # We want to parent a1 -> a2, but a2 has a1 as its parent.
          allow(@a2).to receive(:parent) { @a1 }
          allow(@a1).to receive(:parent) { nil }
          expect(Rooms.has_parent_area(@a2, @a1)).to eq true
        end
        
        it "should return true if parenting to your own grandchild" do
          # We want to parent a1 -> a3, but a3->a2 and a2->a1
          allow(@a3).to receive(:parent) { @a2 }
          allow(@a2).to receive(:parent) { @a1 }
          allow(@a1).to receive(:parent) { nil }
          expect(Rooms.has_parent_area(@a3, @a1)).to eq true
        end
        
        it "should return true if parenting to your own great-grandchild" do
          # We want to parent a1 -> a4, but a4->a3, a3->a2, and a2->a1
          allow(@a4).to receive(:parent) { @a3 }
          allow(@a3).to receive(:parent) { @a2 }
          allow(@a2).to receive(:parent) { @a1 }
          allow(@a1).to receive(:parent) { nil }
          expect(Rooms.has_parent_area(@a4, @a1)).to eq true
        end


      end 
      
      describe :clear_chars_from_room do
        before do
          @target = double
          
          # Stub out welcome room
          @welcome_room = double
          allow(@game).to receive(:welcome_room) { @welcome_room }

          @char_in_room = double
          allow(@target).to receive(:characters) { [@char_in_room] }
          
          stub_translate_for_testing          
        end
    
        it "should tell an online char they're being moved and move them" do
          # Match up a client to the character
          client_in_room = double
          allow(Login).to receive(:find_game_client).with(@char_in_room) { client_in_room }
          expect(client_in_room).to receive(:emit_ooc).with("manage.room_being_cleared")
          expect(Rooms).to receive(:send_to_welcome_room).with(client_in_room, @char_in_room)
          Rooms.clear_chars_from_room(@target)
        end
      
        it "should move disconnected char silently" do
          # Match up a client to the character
          allow(Login).to receive(:find_game_client).with(@char_in_room) { nil }
          expect(Rooms).to receive(:send_to_welcome_room).with(nil, @char_in_room)
          Rooms.clear_chars_from_room(@target)
        end
    
        it "should move them to the welcome room" do
          allow(Login).to receive(:find_game_client).with(@char_in_room) { nil }
          expect(Rooms).to receive(:send_to_welcome_room).with(nil, @char_in_room)
          Rooms.clear_chars_from_room(@target)
        end
      end
    end   
  end
end
