$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Client, "#start" do

    it "starts the server" do
      server = double(ServerController)
      server.stub(:started?) { false }
      client = Client.new(server)
      server.should_receive(:start)
      client.start
    end
  end
end