

require "aresmush"

module AresMUSH

  describe AnsiFormatter do
    
    describe :get_code do
      it "should give code for lowercase x + valid letter" do
        expect(AnsiFormatter.get_code("%xr")).to eq ANSI.red
      end

      it "should give code for uppercase x + valid letter" do
        expect(AnsiFormatter.get_code("%Xb")).to eq ANSI.blue
      end
      
      it "should give code for lowercase c + valid letter" do
        expect(AnsiFormatter.get_code("%cr")).to eq ANSI.red
      end

      it "should give code for uppercase C + valid letter" do
        expect(AnsiFormatter.get_code("%Cb")).to eq ANSI.blue
      end
      
      it "should give code for background color" do
        expect(AnsiFormatter.get_code("%CB")).to eq ANSI.on_blue
      end
      
      it "should give code for a 1-digit FANSI foreground" do
        expect(AnsiFormatter.get_code("%x1")).to eq "\e[38;5;1m" 
      end

      it "should give code for a 2-digit FANSI foreground" do
        expect(AnsiFormatter.get_code("%x12")).to eq "\e[38;5;12m" 
      end

      it "should give code for a 3-digit FANSI foreground" do
        expect(AnsiFormatter.get_code("%x123")).to eq "\e[38;5;123m" 
      end
      
      it "should give code for a FANSI background" do
        expect(AnsiFormatter.get_code("%X1")).to eq "\e[48;5;1m" 
      end
      
      it "should return nil if not ansi" do
        expect(AnsiFormatter.get_code("ABC")).to be_nil
      end
      
      it "should return nil if not a valid ansi letter code" do
        expect(AnsiFormatter.get_code("%xz")).to be_nil
      end
      
      it "should return nil if not a valid FANSI number" do
        expect(AnsiFormatter.get_code("999")).to be_nil
      end

      it "should return nil if FANSI number is too long" do
        expect(AnsiFormatter.get_code("9999")).to be_nil
      end
      
    end
    
  end
end
