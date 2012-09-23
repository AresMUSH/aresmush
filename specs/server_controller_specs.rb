$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ServerController do

    before do
      @good_config = { 'server' => { 'port' => 7207 } }
      @server = double(TCPServer)
    end

    context "sets the state to not started" do
      it do
        @controller = ServerController.new(@server, @good_config)
        @controller.started?.should be_false
      end
    end

    describe :start do
      context "opens the server on the right port" do
        it do
          @controller = ServerController.new(@server, @good_config)
          @server.should_receive(:open).with(7207)
          @controller.start
        end
      end

      context "sets the state to started" do
        it do
          @controller = ServerController.new(@server, @good_config)
          @server.should_receive(:open).with(7207)
          @controller.start
          @controller.started?.should be_true
        end
      end

      context "raises an error if the server is already running" do
        it do
          @controller = ServerController.new(@server, @good_config)
          @server.should_receive(:open).with(7207)
          @controller.start
          expect {@controller.start}.to raise_error("The server is already running.")
        end
      end
    end
  end

end