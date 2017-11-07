require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe Rooms do

      describe :move_to do
        before do
          @old_room = double
          @new_room = double
          
          @client = double
          @char = double
          SpecHelpers.setup_mock_client(@client, @char)
          
          @char.stub(:room) { @old_room }
        
          Rooms.stub(:emit_ooc_to_room)
          @char.stub(:update)
          @char.stub(:name) { "Char" }
          Rooms.stub(:emit_here_desc)
          Places.stub(:clear_place) {}
          Status.stub(:update_last_ic_location) {}
          SpecHelpers.stub_translate_for_testing
        end
      
        it "should emit leaving to the current room" do
          Locale.stub(:translate).with("rooms.char_has_left", :name => "Char") { "has left" }
          Rooms.should_receive(:emit_ooc_to_room).with(@old_room, 'has left')
          Rooms.move_to(@client, @char, @new_room)
        end
      
        it "should emit arriving to the new room" do
          Locale.stub(:translate).with("rooms.char_has_arrived", :name => "Char") { "has arrived" }
          Rooms.should_receive(:emit_ooc_to_room).with(@new_room, 'has arrived')
          Rooms.move_to(@client, @char, @new_room)
        end
      
        it "should update the char location" do
          @char.should_receive(:update).with(room: @new_room)
          Rooms.move_to(@client, @char, @new_room)
        end
      
        it "should emit the new room desc" do
          Rooms.should_receive(:emit_here_desc).with(@client, @char)
          Rooms.move_to(@client, @char, @new_room)
        end
        
        it "should update last IC loc" do
          Status.should_receive(:update_last_ic_location) {}
          Rooms.move_to(@client, @char, @new_room)
        end
        
        it "should clear out their place" do
          Places.should_receive(:clear_place).with(@char) {}
          Rooms.move_to(@client, @char, @new_room)
        end
      end
    end
  end
end