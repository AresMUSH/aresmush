$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Client do

    before do
      AresMUSH::Locale.stub(:translate).with("client.welcome") { "welcome" }
      AresMUSH::Locale.stub(:translate).with("client.anonymous") { "anon" }

      @connection = double
      @client_monitor = double
      @client = Client.new(1, @client_monitor, @connection)
    end

    describe :connected do
      it "should greet the client with the connect config" do
        connect_config = { 'welcome_text' => "Hi", 'welcome_screen' => "Ascii Art" }
        ClientGreeter.should_receive(:greet).with(@client)
        @client.connected
      end
    end
    
    describe :ping do
      it "should ping the connection" do
        @connection.should_receive(:ping)
        @client.ping
      end
    end
    
    describe :emit do
      it "should send the message to the connection" do
        @connection.should_receive(:send_formatted).with("Hi")
        @client.emit "Hi"
      end
    end

    describe :emit_ooc do
      it "should send the message with yellow ansi tags and %% prefix" do
        @connection.should_receive(:send_formatted).with("%xc%% OOC%xn")
        @client.emit_ooc "OOC"
      end
    end    
    
    describe :emit_success do
      it "should send the message with green ansi tags and %% prefix" do
        @connection.should_receive(:send_formatted).with("%xg%% Yay%xn")
        @client.emit_success "Yay"
      end
    end

    describe :emit_failure do
      it "sends the message with green ansi tags and %% prefix" do
        @connection.should_receive(:send_formatted).with("%xr%% Boo%xn")
        @client.emit_failure "Boo"
      end
    end

    describe :handle_input do
      it "should pass the input along to the client monitor" do
        @client_monitor.should_receive(:handle_client_input).with(@client, "Yay")
        @client.handle_input "Yay"
      end
    end

    describe :disconnect do
      it "should close the connection on the next tick" do
        EM.should_receive(:next_tick).and_yield
        @connection.should_receive(:close_connection)
        @client.disconnect
      end
    end
    
    describe :connection_closed do
      it "should notify the client monitor that the connection closed" do
        @client_monitor.should_receive(:connection_closed).with(@client)
        @client.connection_closed
      end
    end 
    
    describe :name do
      it "should use the char name if available" do
        @client.char = {"name" => "Bob"}
        @client.name.should eq "Bob"
      end
      
      it "should use anonymous if there's no char" do
        @client.char = nil
        @client.name.should eq "anon"
      end
      
    end
    
    describe :location do
      it "should use the char location if available" do
        @client.char = {"location" => "111"}
        @client.location.should eq "111"
      end
      
      it "should use nil if there's no char" do
        @client.char = nil
        @client.location.should eq nil
      end
    end
  end
end