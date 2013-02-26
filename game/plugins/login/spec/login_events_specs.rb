$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "login_events"

module AresMUSH
  module Login
    describe LoginEvents do
      before do
        AresMUSH::Locale.stub(:translate).with("login.announce_player_connected", { :name => "Bob" }) { "announce_player_connected" }
        AresMUSH::Locale.stub(:translate).with("login.announce_player_disconnected", { :name => "Bob" }) { "announce_player_disconnected" }
        AresMUSH::Locale.stub(:translate).with("login.announce_player_created", { :name => "Bob" }) { "announce_player_created" }
        AresMUSH::Locale.stub(:translate).with("login.welcome") { "welcome" }
        
        @client_monitor = double(ClientMonitor)
        container = double(Container)
        container.stub(:client_monitor) { @client_monitor }
        @client = double(Client)
        @client.stub(:name) { "Bob" }
        @login_events = LoginEvents.new(container)
      end
      
      describe :on_player_connected do
        it "should announce the player" do
          @client.stub(:emit_success) {}
          @client_monitor.should_receive(:emit_all).with("announce_player_connected")
          @login_events.on_player_connected(:client => @client)
        end
        
        it "should send the welcome text to the connecting player" do
          @client_monitor.stub(:emit_all) {}
          @client.should_receive(:emit_success).with("welcome")
          @login_events.on_player_connected(:client => @client)          
        end        
      end
      
      describe :on_player_created do
        it "should announce the player" do
          @client_monitor.should_receive(:emit_all).with("announce_player_created")
          @login_events.on_player_created(:client => @client)
        end
      end
      
      describe :on_player_disconnected do
        it "should announce the player" do
          @client_monitor.should_receive(:emit_all).with("announce_player_disconnected")
          @login_events.on_player_disconnected(:client => @client)
        end
      end
    end
  end
end