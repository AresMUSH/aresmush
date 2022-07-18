require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe Rooms do
      before do
        @client = double(Client)
        allow(@client).to receive(:name) { "Bob" }

        @room = double
        allow(@client).to receive(:room) { @room }

        @game = double
        allow(Game).to receive(:master) { @game }

        allow(Describe).to receive(:desc_template)
        allow(@room).to receive(:emit_ooc)
        
        @char = double
        @char_id = 111
        allow(Character).to receive(:[]).with(@char_id) { @char  }
        
        allow(AresMUSH::Locale).to receive(:translate).with("rooms.char_has_arrived", { :name => "Bob" }) { "char_has_arrived" }
      end
      
      describe :on_char_connected_event do      
        it "should emit the desc of the char's last location" do
          allow(@client).to receive(:char) { @char }
          @login = CharConnectedEventHandler.new
          expect(Rooms).to receive(:emit_here_desc).with(@client, @char)
          @login.on_event CharConnectedEvent.new(@client, @char_id)
        end
      end
      
      describe :on_char_disconnected_event do   
        before do
          allow(@client).to receive(:char) { @char }
          @welcome_room = double
          allow(@game).to receive(:welcome_room) { @welcome_room }
          allow(@char).to receive(:update)
          @login = CharDisconnectedEventHandler.new
        end
           
        it "should send guests home to the welcome room" do
          allow(@char).to receive(:is_guest?) { true }
          expect(Rooms).to receive(:move_to).with(@client, @char, @welcome_room)
          @login.on_event CharDisconnectedEvent.new(@client, @char_id)
        end
        
        it "should reset guest's client prefs" do
          expect(@char).to receive(:update).with(:screen_reader, false)
          expect(@char).to receive(:update).with(:color_mode, 'FANSI')
        end
        

        it "should not move around regular characters" do
          allow(@char).to receive(:is_guest?) { false }
          expect(Rooms).to_not receive(:move_to)
          @login.on_event CharDisconnectedEvent.new(@client, @char_id)
        end
      end
    end
  end
end
