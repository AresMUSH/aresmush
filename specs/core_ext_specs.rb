$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe String do

    describe :to_ansi do
      it "replaces ansi codes" do
        str = "A%crB%cnC"
        str.to_ansi.should eq "A" + ANSI.red + "B" + ANSI.reset + "C"
      end
      
      it "replaces nested codes" do
        str = "A%cc%cGB%cnC"
        str.to_ansi.should eq "A" + ANSI.cyan + ANSI.on_green + "B" + ANSI.reset + "C"
      end
      
      it "doesn't replace an escaped code" do
        str = "A\\%cc%cGB%cnC"
        str.to_ansi.should eq "A\\%cc" + ANSI.on_green + "B" + ANSI.reset + "C"
      end
    end
  end
end