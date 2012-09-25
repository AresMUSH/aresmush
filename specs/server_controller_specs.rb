$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ServerController do

    before do
      @good_config = { 'server' => { 'port' => 7207 } }
      @server = double(TCPServer)
      @listener = double(ClientListener)
      @config_reader = double(ConfigReader)
      @config_reader.stub(:config) { @good_config }
      @controller = ServerController.new(@server, @config_reader, @listener)
    end

    describe :initialize do
      it "sets the state to not started" do
        @controller.started?.should be_false
      end
    end

    describe :start do
      it "starts accepting connections" do
        @listener.should_receive(:start).with(@server)
        @controller.start
      end

      it "sets the state to started" do
        @listener.should_receive(:start).with(@server)
        @controller.start
        @controller.started?.should be_true
      end

      it "raises an error if the server is already running" do
        # We start it once and then try to start it a second time.
        @listener.should_receive(:start).with(@server)
        @controller.start
        expect {@controller.start}.to raise_error("The server is already running.")
      end
    end
  end

end