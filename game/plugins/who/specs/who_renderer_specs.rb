require_relative "../../plugin_test_loader"

module AresMUSH

  module Who
    describe WhoRenderer do

      include MockClient

      describe "client data handling" do
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

      describe "#initialize" do
        it "should load and compile and existing template" do
          who_renderer = WhoRenderer.new("who.erb")
        end
        it "should fail with a missing template" do
          expect {
            who_renderer = WhoRenderer.new("DOESNOTEXIST.erb")
          }.to raise_error(/No such file or directory/)
        end
      end

      describe "#render" do

        before do
          Global.config_reader = ConfigReader.new
          Global.config_reader.read
          Global.config
          @client_monitor = double("client_monitor")
          Global.stub(:client_monitor) { @client_monitor }

        end

        it "should render output only once" do
          Game.stub(:online_record) { 0 }
          @client_monitor.stub(:logged_in_clients) { [] }
          who_renderer = WhoRenderer.new("who.erb")
          output       = who_renderer.render.to_str
          output.should_not be_nil
          output.scan(/#{Global.config['server']['mush_name']}/).size.should be 1
        end
      end

    end
  end
end


