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
    end
  end
end