require_relative "../../plugin_test_loader"

module AresMUSH

  module Who
    describe WhoRenderer do

      include MockClient
      include GlobalTestHelper

      before do
        stub_global_objects
      end

      describe "client data handling" do
        before do
          @client1 = build_mock_client
          @client2 = build_mock_client
          @client3 = build_mock_client

          @renderer = double
          @renderer.stub(:render) { "ABC" }

          TemplateRenderer.stub(:new) { @renderer }
          client_monitor.stub(:logged_in_clients) { [@client1[:client], @client2[:client], @client3[:client]] }

          @handler = WhoRenderer.new("who.erb")
        end

        it "should create who client data and pass it along" do
          data1 = double
          data2 = double
          data3 = double
          data4 = double
          WhoClientTemplate.should_receive(:new).with(@client1[:client]) { data1 }
          WhoClientTemplate.should_receive(:new).with(@client2[:client]) { data2 }
          WhoClientTemplate.should_receive(:new).with(@client3[:client]) { data3 }
          WhoTemplate.should_receive(:new).with([data1, data2, data3]) { data4 }
          @renderer.should_receive(:render).with(data4)
          @handler.render
        end
      end

    end
  end
end


