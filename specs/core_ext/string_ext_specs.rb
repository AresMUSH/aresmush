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

    describe :titlecase do
      it "should capitalize every word in the title" do
        "a very long engagement".titlecase.should eq "A Very Long Engagement"
      end
    end

    describe :titleize do
      it "should clean up funky spacing and capitalization" do
        "    a VERY long ENgagEMent    ".titleize.should eq "A Very Long Engagement"
      end
    end

    describe :code_gsub do
      it "should replace a code" do
        "A%rB".code_gsub("%r", "Z").should eq "AZB"
      end
      
       it "should replace multiple instances of a code" do
          "A%rB%r".code_gsub("%r", "Z").should eq "AZBZ"
        end
        
      it "should be case-sensitive in its replacements" do
          "A%R".code_gsub("%r", "Z").should eq "A%R"
       end
      
      it "should put in the raw code when preceeded by a single backslash" do
        "A\\%rB".code_gsub("%r", "Z").should eq "A\\%rB"
      end

      it "should put in the raw code when preceeded by two backslashes" do
        "A\\\\%rB".code_gsub("%r", "Z").should eq "A\\\\%rB" 
      end
    end
    
    describe :truncate do
      it "should truncate a string that is too long" do
        "FOOBARBAZ".truncate(4).should eq "FOOB"
      end
      
      it "should do nothing to a string that is not too long" do
        "FOOBARBAZ".truncate(10).should eq "FOOBARBAZ"
      end
      
      it "should return empty if the string is empty" do
        "".truncate(10).should eq ""
      end      
    end
  end
end