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
        AresMUSH::Locale.stub(:translate).with("rooms.announce_char_arrived", { :name => "Bob" }) { "announce_char_arrived" }
      end
      
      describe :on_char_connected do      
        it "should emit the desc of the char's last location" do
          @login.should_receive(:emit_here_desc).with(@client)
          @login.on_char_connected( { :client => @client } )
        end

        it "should announce the char's connection to the room" do
          @room.should_receive(:emit_ooc).with("announce_char_arrived")
          @login.stub(:emit_here_desc)
          @login.on_char_connected( { :client => @client } )
        end
      end
      
      describe :emit_here_desc do
        it "should emit current room desc" do
          Describe.should_receive(:get_desc).with(@room) { "a desc" }
          @client.should_receive(:emit).with("a desc")
          @login.emit_here_desc(@client)
        end
      end      
    end
  end
end