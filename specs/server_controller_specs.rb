$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ServerController do

    before do
      @good_config = { 'server' => { 'port' => 7207 } }
      @server = double(TCPServer)
      @controller = ServerController.new(@server, @good_config)
    end

    describe :initialize do
      it "sets the state to not started" do
        @controller.started?.should be_false
      end
    end

    describe :start do
      it "opens the server on the right port" do
        @server.should_receive(:open).with(7207)
        @controller.start
      end

      it "sets the state to started" do
        @server.should_receive(:open).with(7207)
        @controller.start
        @controller.started?.should be_true
      end

      it "raises an error if the server is already running" do
        @server.should_receive(:open).with(7207)
        @controller.start
        expect {@controller.start}.to raise_error("The server is already running.")
      end
    end
  end

end