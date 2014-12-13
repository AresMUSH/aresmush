$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe AnsiFormatter do
    
    describe :get_code do
      it "should give code for lowercase x + valid letter" do
        AnsiFormatter.get_code("%xr").should eq ANSI.red
      end

      it "should give code for uppercase x + valid letter" do
        AnsiFormatter.get_code("%Xb").should eq ANSI.blue
      end
      
      it "should give code for lowercase c + valid letter" do
        AnsiFormatter.get_code("%cr").should eq ANSI.red
      end

      it "should give code for uppercase C + valid letter" do
        AnsiFormatter.get_code("%Cb").should eq ANSI.blue
      end
      
      it "should give code for background color" do
        AnsiFormatter.get_code("%CB").should eq ANSI.on_blue
      end
      
      it "should give code for a 1-digit FANSI foreground" do
        AnsiFormatter.get_code("%x1").should eq "\e[38;5;1m" 
      end

      it "should give code for a 2-digit FANSI foreground" do
        AnsiFormatter.get_code("%x12").should eq "\e[38;5;12m" 
      end

      it "should give code for a 3-digit FANSI foreground" do
        AnsiFormatter.get_code("%x123").should eq "\e[38;5;123m" 
      end
      
      it "should give code for a FANSI background" do
        AnsiFormatter.get_code("%X1").should eq "\e[48;5;1m" 
      end
      
      it "should return nil if not ansi" do
        AnsiFormatter.get_code("ABC").should be_nil
      end
      
      it "should return nil if not a valid ansi letter code" do
        AnsiFormatter.get_code("%xz").should be_nil
      end
      
      it "should return nil if not a valid FANSI number" do
        AnsiFormatter.get_code("999").should be_nil
      end

      it "should return nil if FANSI number is too long" do
        AnsiFormatter.get_code("9999").should be_nil
      end
      
    end
    
  end
end