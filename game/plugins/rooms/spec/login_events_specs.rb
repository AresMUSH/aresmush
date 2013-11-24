require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe LoginEvents do
      before do
        AresMUSH::Locale.stub(:translate).with("rooms.announce_char_arrived", { :name => "Bob" }) { "announce_char_arrived" }
        
        @client_monitor = double(ClientMonitor)
        Global.stub(:client_monitor) { @client_monitor }
        
        @client = double(Client)
        @client.stub(:name) { "Bob" }
        @client.stub(:location) { "1" }
        @client.stub(:emit)
        
        @client_monitor.stub(:clients)
        Rooms.stub(:room_emit)
        Room.stub(:find_by_id) { [] }
        Describe.stub(:room_desc)

        @login = LoginEvents.new
      end
      
      describe :on_char_connected do
        it "should emit the desc of the char's last location" do
          @login.should_receive(:emit_here_desc).with(@client)
          @login.on_char_connected( { :client => @client } )
        end

        it "should announce the char's connection to the room" do
          clients = double
          @client_monitor.stub(:clients) { clients }
          Rooms.should_receive(:room_emit).with("1", "announce_char_arrived", clients)
          @login.on_char_connected( { :client => @client } )
        end
      end
      
      describe :on_char_created do
        before do
          @login.stub(:set_starting_location) {}
        end
        
        it "should set the starting location" do
          @login.should_receive(:set_starting_location).with(@client)
          @login.on_char_created( { :client => @client } )
        end
        
        it "should emit the desc of the char's last location" do
          @login.should_receive(:emit_here_desc).with(@client)
          @login.on_char_created( { :client => @client } )
        end

        it "should announce the char's connection to the room" do
          clients = double
          @client_monitor.stub(:clients) { clients }
          Rooms.should_receive(:room_emit).with("1", "announce_char_arrived", clients)
          @login.on_char_created( { :client => @client } )
        end
      end
      
      describe :set_starting_location do
        before do
          @char = {}
          @client.stub(:char) { @char }
          Character.stub(:update)
          Game.stub(:get) {{"rooms" => { "welcome_id" => "123" }}}
        end
        
        it "should set the char's location to the welcome room" do
          Game.should_receive(:get) 
          @login.set_starting_location(@client)
          @char["location"].should eq "123"
        end
        
        it "should save the char" do
          Character.should_receive(:update).with(@char)
          @login.set_starting_location(@client)
        end
      end
      
      describe :emit_here_desc do
        it "should find the client's location" do
          @client.should_receive(:location) { "1" }
          Room.should_receive(:find_by_id).with("1")
          @login.emit_here_desc(@client)
        end
        
        it "should get the room desc for the client's location" do
          model = double
          Room.stub(:find_by_id) { [model] }
          Describe.should_receive(:get_desc).with(model)
          @login.emit_here_desc(@client)
        end
        
        it "should emit to the client" do
          model = double
          Room.stub(:find_by_id) { [model] }
          Describe.stub(:get_desc) { "desc" }
          @client.should_receive(:emit).with("desc")
          @login.emit_here_desc(@client)
        end
      end      
    end
  end
end