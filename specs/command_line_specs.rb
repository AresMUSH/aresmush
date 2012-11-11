$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe CommandLine do
    describe :start do
      it "should start the server" do
        server = double(Server)
        command_line = CommandLine.new(server)
        server.should_receive(:start)
        command_line.start
      end
    end
  end
end