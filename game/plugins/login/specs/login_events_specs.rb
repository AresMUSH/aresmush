require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe Login do
      include GlobalTestHelper
      
      before do
        AresMUSH::Locale.stub(:translate).with("login.announce_char_connected", { :name => "Bob" }) { "announce_char_connected" }
        AresMUSH::Locale.stub(:translate).with("login.announce_char_disconnected", { :name => "Bob" }) { "announce_char_disconnected" }
        AresMUSH::Locale.stub(:translate).with("login.announce_char_connected_here", { :name => "Bob" }) { "announce_char_connected_here" }
        AresMUSH::Locale.stub(:translate).with("login.announce_char_disconnected_here", { :name => "Bob" }) { "announce_char_disconnected_here" }
        AresMUSH::Locale.stub(:translate).with("login.announce_char_created", { :name => "Bob" }) { "announce_char_created" }
        stub_global_objects
        
        @room_client = double(Client)
        @room_char = double
        @room = double

        @room_client.stub(:room) { @room }
        @room_char.stub(:room) { @room }
        @room_char.stub(:name) { "Bob" }
        client_monitor.stub(:logged_in) { { @room_client => @room_char } }
        Login.stub(:wants_announce) { false }
        
        @event_char = double
        @event_client = double
        @event_char.stub(:name) { "Bob" }
        @event_char.stub(:room) { nil }    
      end
      
      describe :on_char_connected_event do
        before do
          @event_char.stub(:last_ip) { "127" }
          @event_char.stub(:last_hostname) { "localhost" }
          Login.stub(:update_site_info) {}
          @login_events = CharConnectedEventHandler.new
          @room_client.stub(:emit_success)
          dispatcher.stub(:queue_timer)
        end
        
        it "should update the site info" do
          Login.should_receive(:update_site_info).with(@event_client, @event_char) {}
          @login_events.on_event CharConnectedEvent.new(@event_client, @event_char)
        end
        
        it "should announce the char if the client wants it" do
          Login.stub(:wants_announce) { true }
          @room_client.should_receive(:emit_ooc).with("announce_char_connected")
          @login_events.on_event CharConnectedEvent.new(@event_client, @event_char)
        end

        it "should not announce the char if the client doesn't want it" do
          Login.stub(:wants_announce) { false }
          @room_client.should_not_receive(:emit_ooc)
          @login_events.on_event CharConnectedEvent.new(@event_client, @event_char)
        end
        
        it "should announce the char in the room" do
          @event_char.stub(:room) { @room }
          @room_client.should_receive(:emit_success).with("announce_char_connected_here")
          @login_events.on_event CharConnectedEvent.new(@event_client, @event_char)
        end
        
        it "should check for suspect site on the first login" do
          @event_char.stub(:last_ip) { nil }
          Login.should_receive(:check_for_suspect).with(@event_char) {}
          @login_events.on_event CharCreatedEvent.new(@event_client, @event_char)
        end

        it "should not check for suspect site on subsequent login" do
          Login.should_not_receive(:check_for_suspect).with(@event_char) {}
          @login_events.on_event CharCreatedEvent.new(@event_client, @event_char)
        end
        
      end
      
      describe :on_char_created_event do
        before do
          Login.stub(:update_site_info) {}
          Login.stub(:check_for_suspect) {}
          client_monitor.stub(:emit_all_ooc)
          @login_events = CharCreatedEventHandler.new
        end
        
        it "should announce the char" do
          client_monitor.should_receive(:emit_all_ooc).with("announce_char_created")
          @login_events.on_event CharCreatedEvent.new(@event_client, @event_char)
        end
      end
      
      describe :on_char_disconnected_event do
        before do
          @login_events = CharDisconnectedEventHandler.new
        end
        
        it "should announce the char if the client wants it" do
          Login.stub(:wants_announce) { true }
          @room_client.should_receive(:emit_ooc).with("announce_char_disconnected")
          @login_events.on_event CharDisconnectedEvent.new(@event_client, @event_char)
        end
        
        it "should not announce the char if the client doesn't want it" do
          Login.stub(:wants_announce) { false }
          @room_client.should_not_receive(:emit_ooc)
          @login_events.on_event CharDisconnectedEvent.new(@event_client, @event_char)
        end

        it "should announce the char in the room" do
          @event_char.stub(:room) { @room }
          @room_client.should_receive(:emit_success).with("announce_char_disconnected_here")
          @login_events.on_event CharDisconnectedEvent.new(@event_client, @event_char)
        end
      end
    end
  end
end