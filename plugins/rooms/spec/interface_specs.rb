require "plugin_test_loader"

module AresMUSH
  module Rooms
    describe Rooms do

      describe :move_to do
        before do
          @old_room = double
          @new_room = double
          
          @client = double
          @char = double
          setup_mock_client(@client, @char)
          
          allow(@char).to receive(:room) { @old_room }
          allow(@client).to receive(:screen_reader) { false }
          allow(@old_room).to receive(:emit_ooc)
          allow(@new_room).to receive(:emit_ooc)
          allow(@char).to receive(:update)
          allow(@char).to receive(:name) { "Char" }
          allow(Rooms).to receive(:emit_here_desc)
          allow(Places).to receive(:clear_place) {}
          allow(Status).to receive(:update_last_ic_location) {}
          stub_translate_for_testing
        end
      
        it "should emit leaving to the current room" do
          allow(Locale).to receive(:translate).with("rooms.char_has_left", :name => "Char") { "has left" }
          expect(@old_room).to receive(:emit_ooc).with('has left')
          Rooms.move_to(@client, @char, @new_room)
        end
      
        it "should emit arriving to the new room" do
          allow(Locale).to receive(:translate).with("rooms.char_has_arrived", :name => "Char") { "has arrived" }
          expect(@new_room).to receive(:emit_ooc).with('has arrived')
          Rooms.move_to(@client, @char, @new_room)
        end
      
        it "should update the char location" do
          expect(@char).to receive(:update).with(room: @new_room)
          Rooms.move_to(@client, @char, @new_room)
        end
      
        it "should emit the new room desc" do
          expect(Rooms).to receive(:emit_here_desc).with(@client, @char)
          Rooms.move_to(@client, @char, @new_room)
        end
        
        it "should not emit the new room desc if screen reader enabled" do
          allow(@client).to receive(:screen_reader) { true }
          allow(@new_room).to receive(:name) { "Somewhere" }
          expect(Rooms).to_not receive(:emit_here_desc).with(@client, @char)
          expect(@client).to receive(:emit_ooc).with ("rooms.screen_reader_arrived")
          Rooms.move_to(@client, @char, @new_room)
        end
        
        it "should update last IC loc" do
          expect(Status).to receive(:update_last_ic_location) {}
          Rooms.move_to(@client, @char, @new_room)
        end
        
        it "should clear out their place" do
          expect(Places).to receive(:clear_place).with(@char, @old_room) {}
          Rooms.move_to(@client, @char, @new_room)
        end
      end
    end
  end
end
