$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe CommandLine, "#start" do

    it "starts the controller" do
      controller = double(ServerController)
      command_line = CommandLine.new(controller)
      controller.should_receive(:start)
      command_line.start
    end
  end
end