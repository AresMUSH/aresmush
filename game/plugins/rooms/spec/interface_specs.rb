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
        
          @old_room.stub(:emit_ooc)
          @new_room.stub(:emit_ooc)
          @char.stub(:save!)
          @char.stub(:room=)
          @char.stub(:name) { "Char" }
          Rooms.stub(:emit_here_desc)
        
          SpecHelpers.stub_translate_for_testing
        end
      
        it "should emit leaving to the current room" do
          Locale.stub(:translate).with("rooms.char_has_left", :name => "Char") { "has left" }
          @old_room.should_receive(:emit_ooc).with('has left')
          Rooms.move_to(@client, @char, @new_room)
        end
      
        it "should emit arriving to the new room" do
          Locale.stub(:translate).with("rooms.char_has_arrived", :name => "Char") { "has arrived" }
          @new_room.should_receive(:emit_ooc).with('has arrived')
          Rooms.move_to(@client, @char, @new_room)
        end
      
        it "should update the char location" do
          @char.should_receive(:room=).with(@new_room)
          @char.should_receive(:save!)
          Rooms.move_to(@client, @char, @new_room)
        end
      
        it "should emit the new room desc" do
          Rooms.should_receive(:emit_here_desc).with(@client, @char)
          Rooms.move_to(@client, @char, @new_room)
        end
      end
    end
  end
end