$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe String do

    describe :to_ansi do
      it "replaces ansi codes" do
        str = "A%xrB%xnC"
        str.to_ansi.should eq "A" + ANSI.red + "B" + ANSI.reset + "C"
      end
      
      it "replaces nested codes" do
        str = "A%xc%xGB%xnC"
        str.to_ansi.should eq "A" + ANSI.cyan + ANSI.on_green + "B" + ANSI.reset + "C"
      end
      
      it "doesn't replace a code preceeded by a single backslash" do
        str = "A\\%xcB"
        str.to_ansi.should eq "A\\%xcB"
      end
      
      it "replaces a code preceeded by two backslashes" do
        str = "A\\\\%xcB"
        str.to_ansi.should eq "A\\\\" + ANSI.cyan + "B"
      end

      it "doesn't replace a code preceeded by three backslashes" do
        str = "A\\\\\\%xcB"
        str.to_ansi.should eq "A\\\\\\%xcB"
      end

      it "replaces a code preceeded by four backslashes" do
          str = "A\\\\\\\\%xcB"
          str.to_ansi.should eq "A\\\\\\\\" + ANSI.cyan + "B"
      end

    end
  end
end