$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe String do

    describe :to_ansi do
      it "replaces ansi codes" do
        str = "A%crB%cnC"
        str.to_ansi.should eq "A" + ANSI.red + "B" + ANSI.reset + "C"
      end
    end
  end
end