require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe LoginEvents do
      include GlobalTestHelper
      
      before do
        AresMUSH::Locale.stub(:translate).with("login.announce_char_connected", { :name => "Bob" }) { "announce_char_connected" }
        AresMUSH::Locale.stub(:translate).with("login.announce_char_disconnected", { :name => "Bob" }) { "announce_char_disconnected" }
        AresMUSH::Locale.stub(:translate).with("login.announce_char_connected_here", { :name => "Bob" }) { "announce_char_connected_here" }
        AresMUSH::Locale.stub(:translate).with("login.announce_char_disconnected_here", { :name => "Bob" }) { "announce_char_disconnected_here" }
        AresMUSH::Locale.stub(:translate).with("login.announce_char_created", { :name => "Bob" }) { "announce_char_created" }
        stub_global_objects
        
        @client = double(Client)
        @char = double
        @room = double
        @client.stub(:char) { @char }
        @client.stub(:room) { @room }
        client_monitor.stub(:logged_in_clients) { [@client] }
        
        @other_client = double
        @other_client.stub(:room) { nil }
        @other_client.stub(:char) { nil }
        @other_client.stub(:name) { "Bob" }

        @login_events = LoginEvents.new
      end
      
      describe :on_char_connected_event do
        before do
        end
        
        it "should announce the char if the client wants it" do
          Login.stub(:wants_announce) { true }
          @client.should_receive(:emit_ooc).with("announce_char_connected")
          @login_events.on_char_connected_event CharConnectedEvent.new(@other_client)
        end

        it "should not announce the char if the client doesn't want it" do
          Login.stub(:wants_announce) { false }
          @client.should_not_receive(:emit_ooc)
          @login_events.on_char_connected_event CharConnectedEvent.new(@other_client)
        end
        
        it "should announce the char in the room" do
          @other_client.stub(:room) { @room }
          @client.should_receive(:emit_success).with("announce_char_connected_here")
          @login_events.on_char_connected_event CharConnectedEvent.new(@other_client)
        end
      end
      
      describe :on_char_created_event do
        it "should announce the char" do
          client_monitor.should_receive(:emit_all_ooc).with("announce_char_created")
          @login_events.on_char_created_event CharCreatedEvent.new(@other_client)
        end
      end
      
      describe :on_char_disconnected_event do
        it "should announce the char if the client wants it" do
          Login.stub(:wants_announce) { true }
          @client.should_receive(:emit_ooc).with("announce_char_disconnected")
          @login_events.on_char_disconnected_event CharDisconnectedEvent.new(@other_client)
        end
        
        it "should not announce the char if the client doesn't want it" do
          Login.stub(:wants_announce) { false }
          @client.should_not_receive(:emit_ooc)
          @login_events.on_char_disconnected_event CharDisconnectedEvent.new(@other_client)
        end

        it "should announce the char in the room" do
          @other_client.stub(:room) { @room }
          @client.should_receive(:emit_success).with("announce_char_disconnected_here")
          @login_events.on_char_disconnected_event CharDisconnectedEvent.new(@other_client)
        end
      end
    end
  end
end