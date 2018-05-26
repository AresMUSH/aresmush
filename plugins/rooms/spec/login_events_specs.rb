require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe Rooms do
      before do
        @client = double(Client)
        @client.stub(:name) { "Bob" }

        @room = double
        @client.stub(:room) { @room }

        @game = double
        Game.stub(:master) { @game }

        Describe.stub(:desc_template)
        @room.stub(:emit_ooc)
        
        @char = double
        @char_id = 111
        Character.stub(:[]).with(@char_id) { @char  }
        
        AresMUSH::Locale.stub(:translate).with("rooms.char_has_arrived", { :name => "Bob" }) { "char_has_arrived" }
      end
      
      describe :on_char_connected_event do      
        it "should emit the desc of the char's last location" do
          @client.stub(:char) { @char }
          @login = CharConnectedEventHandler.new
          Rooms.should_receive(:emit_here_desc).with(@client, @char)
          @login.on_event CharConnectedEvent.new(@client, @char_id)
        end
      end
      
      describe :on_char_disconnected_event do   
        before do
          @client.stub(:char) { @char }
          @welcome_room = double
          @game.stub(:welcome_room) { @welcome_room }
          @login = CharDisconnectedEventHandler.new
        end
           
        it "should send guests home to the welcome room" do
          @char.stub(:is_guest?) { true }
          Rooms.should_receive(:move_to).with(@client, @char, @welcome_room)
          @login.on_event CharDisconnectedEvent.new(@client, @char_id)
        end

        it "should not move around regular characters" do
          @char.stub(:is_guest?) { false }
          Rooms.should_not_receive(:move_to)
          @login.on_event CharDisconnectedEvent.new(@client, @char_id)
        end
      end
    end
  end
end