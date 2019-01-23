require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe Login do
      include GlobalTestHelper
      
      before do
        allow(AresMUSH::Locale).to receive(:translate).with("login.announce_char_connected", { :name => "Bob" }) { "announce_char_connected" }
        allow(AresMUSH::Locale).to receive(:translate).with("login.announce_char_disconnected", { :name => "Bob" }) { "announce_char_disconnected" }
        allow(AresMUSH::Locale).to receive(:translate).with("login.announce_char_connected_here", { :name => "Bob" }) { "announce_char_connected_here" }
        allow(AresMUSH::Locale).to receive(:translate).with("login.announce_char_disconnected_here", { :name => "Bob" }) { "announce_char_disconnected_here" }
        allow(AresMUSH::Locale).to receive(:translate).with("login.announce_char_created", { :name => "Bob" }) { "announce_char_created" }
        stub_global_objects
        
        @room_client = double(Client)
        @room_char = double
        @room = double

        allow(@room_client).to receive(:room) { @room }
        allow(@room_char).to receive(:room) { @room }
        allow(@room_char).to receive(:name) { "Bob" }
        allow(client_monitor).to receive(:logged_in) { { @room_client => @room_char } }
        allow(notifier).to receive(:notify_ooc)
        allow(Login).to receive(:wants_announce) { false }
        allow(Login).to receive(:is_online?) { true }
        
        @event_char = double
        @event_client = double
        allow(@event_char).to receive(:name) { "Bob" }
        allow(@event_char).to receive(:room) { nil }    

        @event_char_id = 111
        allow(Character).to receive(:[]).with(@event_char_id) { @event_char }
      end
      
      describe :on_char_connected_event do
        before do
          allow(@event_char).to receive(:last_ip) { "127" }
          allow(@event_char).to receive(:last_hostname) { "localhost" }
          allow(@event_char).to receive(:room) { @room }
          allow(@room).to receive(:emit_success)
          allow(Login).to receive(:update_site_info) {}
          @login_events = CharConnectedEventHandler.new
          allow(@room_client).to receive(:emit_success)
          allow(@event_char).to receive(:onconnect_commands) { [] }
          allow(dispatcher).to receive(:queue_timer)
        end
        
        it "should update the site info" do
          expect(Login).to receive(:update_site_info).with(@event_client, @event_char) {}
          @login_events.on_event CharConnectedEvent.new(@event_client, @event_char_id)
        end
        
        it "should announce the char if the client wants it but is in a different room" do
          expect(Login).to receive(:wants_announce).with(@room_char, @event_char) { true }
          allow(@room_char).to receive(:room) { double }
          expect(@room_client).to receive(:emit_ooc).with("announce_char_connected")
          @login_events.on_event CharConnectedEvent.new(@event_client, @event_char_id)
        end

        it "should not announce the char if the client doesn't want it" do
          allow(Login).to receive(:wants_announce) { false }
          expect(@room_client).to_not receive(:emit_ooc)
          @login_events.on_event CharConnectedEvent.new(@event_client, @event_char_id)
        end
        
        it "should announce the char in the room" do
          expect(@room).to receive(:emit_success).with("announce_char_connected_here")
          @login_events.on_event CharConnectedEvent.new(@event_client, @event_char_id)
        end
        
        it "should check for suspect site on the first login" do
          allow(@event_char).to receive(:last_ip) { nil }
          expect(Login).to receive(:check_for_suspect).with(@event_char) {}
          @login_events.on_event CharCreatedEvent.new(@event_client, @event_char_id)
        end

        it "should not check for suspect site on subsequent login" do
          expect(Login).to_not receive(:check_for_suspect).with(@event_char) {}
          @login_events.on_event CharCreatedEvent.new(@event_client, @event_char_id)
        end
        
      end
      
      describe :on_char_created_event do
        before do
          allow(Login).to receive(:update_site_info) {}
          allow(Login).to receive(:check_for_suspect) {}
          @login_events = CharCreatedEventHandler.new
        end
        
        it "should announce the char" do
          expect(notifier).to receive(:notify_ooc).with(:char_created, "announce_char_created")
          @login_events.on_event CharCreatedEvent.new(@event_client, @event_char_id)
        end
      end
      
      describe :on_char_disconnected_event do
        before do
          @login_events = CharDisconnectedEventHandler.new
          allow(@event_char).to receive(:room) { @room }
          allow(@room).to receive(:emit_success)
        end
        
        it "should announce the char if the client wants it but is in a different room" do
          expect(Login).to receive(:wants_announce).with(@room_char, @event_char) { true }
          allow(@room_char).to receive(:room) { double }
          expect(@room_client).to receive(:emit_ooc).with("announce_char_disconnected")
          @login_events.on_event CharDisconnectedEvent.new(@event_client, @event_char_id)
        end
        
        it "should not announce the char if the client doesn't want it" do
          allow(Login).to receive(:wants_announce) { false }
          expect(@room_client).to_not receive(:emit_ooc)
          @login_events.on_event CharDisconnectedEvent.new(@event_client, @event_char_id)
        end

        it "should announce the char in the room" do
          expect(@room).to receive(:emit_success).with("announce_char_disconnected_here")
          @login_events.on_event CharDisconnectedEvent.new(@event_client, @event_char_id)
        end
      end
    end
  end
end
