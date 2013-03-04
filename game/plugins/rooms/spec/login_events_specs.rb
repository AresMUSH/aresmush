require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe LoginEvents do
      before do
        AresMUSH::Locale.stub(:translate).with("rooms.announce_player_arrived", { :name => "Bob" }) { "announce_player_arrived" }
        
        container = double(Container)
        @client_monitor = double(ClientMonitor)
        @client = double(Client)

        container.stub(:client_monitor) { @client_monitor }
        @client.stub(:name) { "Bob" }

        @login = LoginEvents.new(container)
      end
      
      describe :on_player_connected do
        it "should emit the desc of the player's last location" do
          Describe.should_receive(:emit_here_desc).with(@client)
          @client.stub(:emit_to_location)
          @login.on_player_connected( { :client => @client } )
        end

        it "should announce the player's connection to the room" do
          Describe.stub(:emit_here_desc)
          @client.should_receive(:emit_to_location).with("announce_player_arrived")
          @login.on_player_connected( { :client => @client } )
        end
      end
      
      describe :on_player_created do
        before do
          @login.stub(:set_starting_location) {}
          Describe.stub(:emit_here_desc)
          @client.stub(:emit_to_location)
        end
        
        it "should set the starting location" do
          @login.should_receive(:set_starting_location).with(@client)
          @login.on_player_created( { :client => @client } )
        end
        
        it "should emit the desc of the player's last location" do
          Describe.should_receive(:emit_here_desc).with(@client)
          @login.on_player_created( { :client => @client } )
        end

        it "should announce the player's connection to the room" do
          @client.should_receive(:emit_to_location).with("announce_player_arrived")
          @login.on_player_created( { :client => @client } )
        end
      end
      
      describe :set_starting_location do
        before do
          @player = {}
          @client.stub(:player) { @player }
          Player.stub(:update)
          Game.stub(:get) {{"rooms" => { "welcome_id" => "123" }}}
        end
        
        it "should set the player's location to the welcome room" do
          Game.should_receive(:get) 
          @login.set_starting_location(@client)
          @player["location"].should eq "123"
        end
        
        it "should save the player" do
          Player.should_receive(:update).with(@player)
          @login.set_starting_location(@client)
        end
      end      
    end
  end
end