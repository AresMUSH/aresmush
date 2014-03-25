require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoCmd do
      include PluginCmdTestHelper
      include MockClient

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
        it "should read the template" do
          TemplateRenderer.should_receive(:create_from_file) do |file|
            file.end_with?("who.erb").should be_true
          end
          WhoCmd.new
        end
      end
      
      describe :handle do        
        before do
          @client1 = build_mock_client
          @client2 = build_mock_client
          @client3 = build_mock_client
          
          @renderer = double
          @renderer.stub(:render) { "ABC" }
          
          TemplateRenderer.stub(:new) { @renderer }
          
          client_monitor = double
          Global.stub(:client_monitor) { client_monitor }
          client_monitor.stub(:logged_in_clients) { [@client1[:client], @client2[:client], @client3[:client]] }
          
          # Need to do this again now that we've stubbed out the client monitor.
          init_handler(WhoCmd, "who")                 
        end

        it "should create who client data and pass it along" do
          client.stub(:emit)
          data1 = double
          data2 = double
          data3 = double
          data4 = double
          WhoClientData.should_receive(:new).with(@client1[:client]) { data1 }
          WhoClientData.should_receive(:new).with(@client2[:client]) { data2 }
          WhoClientData.should_receive(:new).with(@client3[:client]) { data3 }
          WhoData.should_receive(:new).with([data1, data2, data3]) { data4 }
          @renderer.should_receive(:render).with(data4)
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