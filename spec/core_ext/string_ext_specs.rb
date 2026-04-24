

require "aresmush"

module AresMUSH

  describe String do

    describe :first do
      it "returns the first part if there is a separator" do
        expect("A:B".first(":")).to eq "A"
      end

      it "returns the whole string if there is no separator" do
        expect("AB-C".first(":")).to eq "AB-C"
      end

      it "returns an empty string if the separator is at the front" do
        expect(":AB".first(":")).to eq ""
      end
    end

    describe :rest do
      it "returns the first part if there is a separator" do
        expect("A:B:C:D".rest(":")).to eq "B:C:D"
      end

      it "returns empty if there is no separator" do
        expect("AB-C".rest(":")).to eq ""
      end

      it "returns the rest of the string even if the separator is at the front" do
        expect(":AB".rest(":")).to eq "AB"
      end

      it "returns an empty string if the only separator is at the end" do
        expect("AB:".rest(":")).to eq ""
      end

      it "returns a properly joined string an extra seprator is at the end" do
        expect("AB:C:".rest(":")).to eq "C:"
      end
    end

    describe :titlecase do
      it "should capitalize every word in the title" do
        expect("a very long engagement".titlecase).to eq "A Very Long Engagement"
      end
    end

    describe :titlecase do
      it "should clean up funky spacing and capitalization" do
        expect("    a VERY long ENgagEMent    ".titlecase).to eq "A Very Long Engagement"
      end
    end

    describe :code_gsub do
      it "should replace a code" do
        expect("A%rB".code_gsub("%r", "Z")).to eq "AZB"
      end
      
       it "should replace multiple instances of a code" do
          expect("A%rB%r".code_gsub("%r", "Z")).to eq "AZBZ"
        end
        
      it "should be case-sensitive in its replacements" do
          expect("A%R".code_gsub("%r", "Z")).to eq "A%R"
       end
      
      it "should put in the raw code when preceeded by a single backslash" do
        expect("A\\%rB".code_gsub("%r", "Z")).to eq "A\\%rB"
      end

      it "should put in the raw code when preceeded by two backslashes" do
        x = "A\\\\%rB".code_gsub("%r", "Z")
        expect(x).to eq "A\\\\%rB" 
      end

      it "should put in the raw code when preceeded by two backslashes" do
        expect("A\\\\%rB".code_gsub("%r", "Z")).to eq "A\\\\%rB" 
      end
    end
    
    describe :truncate do
      it "should truncate a string that is too long" do
        expect("FOOBARBAZ".truncate(4)).to eq "FOOB"
      end
      
      it "should do nothing to a string that is not too long" do
        expect("FOOBARBAZ".truncate(10)).to eq "FOOBARBAZ"
      end
      
      it "should return empty if the string is empty" do
        expect("".truncate(10)).to eq ""
      end      
    end
    
    describe :underscore do
      it "should translate CamelCase into undescores" do
        expect("CamelCase".underscore).to eq "camel_case"
      end
    end
    
    describe :is_integer? do
      it "should return true for a number" do
        expect("1".is_integer?).to be true
      end
      
      it "should return true for a multi-digit number" do
        expect("123".is_integer?).to be true
      end
      
      it "should return false for not a number" do
        expect("x".is_integer?).to be false
      end
      
      it "should return false for empty string" do
        expect("".is_integer?).to be false
      end
      
      it "should return false for a float" do
        expect("1.2".is_integer?).to be false
      end

      it "should return false for a number mixed with string" do
        expect("12ABC".is_integer?).to be false
      end
    end
    
    describe :repeat do
      it "should repeat the string x times" do
        expect("x".repeat(5)).to eq "xxxxx"
      end
      
      it "should work with multiple chars" do
        expect("ab".repeat(3)).to eq "ababab"
      end
    end
    
    describe :to_bool do
      it "should return false for falsey things" do
        expect("".to_bool).to eq false
        expect("f".to_bool).to eq false
        expect("false".to_bool).to eq false
        expect("0".to_bool).to eq false
        expect("n".to_bool).to eq false
        expect("no".to_bool).to eq false
        expect("null".to_bool).to eq false        
      end
      
      it "should return true for truthy things" do
        expect("true".to_bool).to eq true
        expect("t".to_bool).to eq true
        expect("yes".to_bool).to eq true
        expect("y".to_bool).to eq true
        expect("1".to_bool).to eq true
      end
      
      it "should be case-insensitive" do
        expect("TRUE".to_bool).to eq true
        expect("FALSE".to_bool).to eq false
      end
    end
    
  end
end
