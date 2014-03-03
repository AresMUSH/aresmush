require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoCmd do
      include PluginCmdTestHelper

      before do        
        init_handler(WhoCmd, "who")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that doesn't allow args"
      it_behaves_like "a plugin that expects a single root" do
        let(:expected_root) { "who" }
      end
      
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
      
      describe :handle do        
        before do
          @client1 = double("Client1")
          @client2 = double("Client2")
          
          @renderer = double
          @renderer.stub(:render) { "ABC" }
          
          WhoRenderer.stub(:new) { @renderer }
          
          client_monitor = double
          Global.stub(:client_monitor) { client_monitor }
          client_monitor.stub(:logged_in_clients) { [@client1, @client2] }
          
          # Need to do this again now that we've stubbed out the client monitor.
          init_handler(WhoCmd, "who")                 
        end

        it "should call the renderer with the clients" do
          client.stub(:emit)
          @renderer.should_receive(:render).with([@client1, @client2]) { "" }
          handler.handle
        end
        
        it "should emit the results of the render methods" do
          client.should_receive(:emit).with("ABC")
          handler.handle
        end
      end
    end
  end
end