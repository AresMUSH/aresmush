require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe Who do

      describe :initialize do
        it "should read the templates" do
          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("header.lq").should be_true
          end

          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("character.lq").should be_true
          end

          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("footer.lq").should be_true
          end
          WhoCmd.new
        end
        
        it "should initialize the renderer" do
          TemplateRenderer.should_receive(:create_from_file) { 1 }
          TemplateRenderer.should_receive(:create_from_file) { 2 }
          TemplateRenderer.should_receive(:create_from_file) { 3 }
          WhoRenderer.should_receive(:new).with(1, 2, 3)
          WhoCmd.new
        end
      end
      
      describe :want_command do
        before do
          @who = WhoCmd.new
          @cmd = double
        end
        
        it "should want the who command" do
          @cmd.stub(:root_is?).with("who") { true }
          @who.want_command?(@cmd).should be_true
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("who") { false }
          @who.want_command?(@cmd).should be_false
        end        
      end

      describe :on_command do        
        before do
          @client_monitor = double(ClientMonitor)
          Global.stub(:client_monitor) { @client_monitor }
          @client = double
          
          @client1 = double("Client1")
          @client2 = double("Client2")
          @client_monitor.stub(:logged_in_clients) { [@client1, @client2] }
          
          @renderer = double
          WhoRenderer.stub(:new) { @renderer }
          @who = WhoCmd.new
        end

        it "should call the renderer with the clients" do
          @client.stub(:emit)
          @renderer.should_receive(:render).with([@client1, @client2]) { "" }
          @who.on_command(@client, @cmd)
        end
        
        it "should emit the results of the render methods" do
          @renderer.stub(:render) { "ABC" }
          @client.should_receive(:emit).with("ABC")
          @who.on_command(@client, @cmd)
        end
      end
    end
  end
end