require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe Who do
      before do
        @cmd = double
        @client_monitor = double(ClientMonitor)
        @client = double(Client).as_null_object
        Global.stub(:client_monitor) { @client_monitor }
        @who = WhoCmd.new
      end

      describe :want_command do
        it "should want the who command" do
          @cmd.stub(:root_is?).with("who") { true }
          @who.want_command?(@cmd).should be_true
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("who") { false }
          @who.want_command?(@cmd).should be_false
        end        
      end

      describe :want_anon_command do
        it "should want the who command" do
          @cmd.stub(:root_is?).with("who") { true }
          @who.want_command?(@cmd).should be_true
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("who") { false }
          @who.want_command?(@cmd).should be_false
        end
      end

      describe :on_anon_command do
        it "should call show who" do
          @who.should_receive(:show_who).with(@client)
          @who.on_command(@client, double(Command))
        end
      end

      describe :on_command do
        it "should call show who" do
          @who.should_receive(:show_who).with(@client)
          @who.on_command(@client, double(Command))
        end
      end

      describe :show_who do
        before do
          @client1 = double("Client1")
          @client2 = double("Client2")

          # Stub some people logged in
          @client_monitor.stub(:clients) { [@client1, @client2] }
          @client1.stub(:logged_in?) { true }
          @client2.stub(:logged_in?) { false }

          WhoRenderer.stub(:format)
        end

        it "should call the renderer with the logged in chars" do
          @client_monitor.should_receive(:clients) { [@client1, @client2] }
          @client1.should_receive(:logged_in?) { false }
          @client2.should_receive(:logged_in?) { true }
          WhoRenderer.should_receive(:render).with([@client2]) { "" }
          @who.show_who(@client)
        end

        it "should call the renderer" do
          WhoRenderer.should_receive(:render).with([@client1]) { "ABC" }
          @who.show_who(@client)
        end
        
        it "should emit the results of the render methods" do
          WhoRenderer.stub(:render).with([@client1]) { "ABC" }
          @client.should_receive(:emit).with("ABC")
          @who.show_who(@client)
        end
      end
    end
  end
end