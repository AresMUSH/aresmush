require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe LoginEvents do
      before do
        @client = double(Client)
        @client.stub(:name) { "Bob" }

        @room = double
        @client.stub(:room) { @room }

        Describe.stub(:get_desc)
        @room.stub(:emit_ooc)
        
        @login = LoginEvents.new
        AresMUSH::Locale.stub(:translate).with("rooms.char_has_arrived", { :name => "Bob" }) { "char_has_arrived" }
      end
      
      describe :on_char_connected do      
        it "should emit the desc of the char's last location" do
          Rooms.should_receive(:emit_here_desc).with(@client)
          @login.on_char_connected( { :client => @client } )
        end

        it "should announce the char's connection to the room" do
          @room.should_receive(:emit_ooc).with("char_has_arrived")
          Rooms.stub(:emit_here_desc)
          @login.on_char_connected( { :client => @client } )
        end
      end
      
      describe :on_char_disconnected do   
        before do
          @char = double
          @client.stub(:char) { @char }
          @welcome_room = double
          game = double
          Game.stub(:master) { game }
          game.stub(:welcome_room) { @welcome_room }
        end
           
        it "should send guests home to the welcome room" do
          @char.stub(:has_role?).with("guest") { true }
          Rooms.should_receive(:move_to).with(@client, @char, @welcome_room)
          @login.on_char_disconnected( { :client => @client } )
        end

        it "should not move around regular characters" do
          @char.stub(:has_role?).with("guest") { false }
          Rooms.should_not_receive(:move_to)
          @login.on_char_disconnected( { :client => @client } )
        end
      end
    end
  end
end