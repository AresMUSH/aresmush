$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Client, "#start" do

    it "starts the controller" do
      controller = double(ServerController)
      client = Client.new(controller)
      controller.should_receive(:start)
      client.start
    end
  end
end