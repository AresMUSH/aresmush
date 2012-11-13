$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe String do

    describe :first do
      it "returns the first part if there is a separator" do
        "A:B".first(":").should eq "A"
      end

      it "returns the whole string if there is no separator" do
        "AB-C".first(":").should eq "AB-C"
      end

      it "returns an empty string if the separator is at the front" do
        ":AB".first(":").should eq ""
      end
    end
    
    describe :rest do
      it "returns the first part if there is a separator" do
        "A:B:C:D".rest(":").should eq "B:C:D"
      end

      it "returns the whole string if there is no separator" do
        "AB-C".rest(":").should eq "AB-C"
      end
      
      it "returns the rest of the string even if the separator is at the front" do
        ":AB".rest(":").should eq "AB"
      end

      it "returns an empty string if the only separator is at the end" do
        "AB:".rest(":").should eq ""
      end

      it "returns a properly joined string an extra seprator is at the end" do
        "AB:C:".rest(":").should eq "C:"
      end
    end
    
    describe :to_ansi do
      it "replaces ansi codes" do
        str = "A%xrB%xnC"
        str.to_ansi.should eq "A" + ANSI.red + "B" + ANSI.reset + "C" + ANSI.reset
      end
      
      it "replaces nested codes" do
        str = "A%xc%xGB%xnC"
        str.to_ansi.should eq "A" + ANSI.cyan + ANSI.on_green + "B" + ANSI.reset + "C" + ANSI.reset
      end
      
      it "doesn't replace a code preceeded by a single backslash" do
        str = "A\\%xcB" 
        str.to_ansi.should eq "A\\%xcB" + ANSI.reset
      end
      
      it "replaces a code preceeded by two backslashes" do
        str = "A\\\\%xcB"
        str.to_ansi.should eq "A\\\\" + ANSI.cyan + "B" + ANSI.reset
      end

      it "doesn't replace a code preceeded by three backslashes" do
        str = "A\\\\\\%xcB"
        str.to_ansi.should eq "A\\\\\\%xcB" + ANSI.reset
      end

      it "replaces a code preceeded by four backslashes" do
          str = "A\\\\\\\\%xcB"
          str.to_ansi.should eq "A\\\\\\\\" + ANSI.cyan + "B" + ANSI.reset
      end      
    end
  end
end