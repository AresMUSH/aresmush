$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Database do
    describe :connect do
      it "should connect on the configured host and port" do
        # TODO
      end

      it "should authenticate using the configured username and password" do
        # TODO
      end

      it "should re-raise an exception if there's a problem connecting to the db" do
        # TODO
      end
    end
  end
end