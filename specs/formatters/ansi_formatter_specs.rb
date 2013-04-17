$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe AnsiFormatter do
    
    describe :format do
      it "should replace ansi codes" do
        AnsiFormatter.format("A%xrB%XnC").should eq "A" + ANSI.red + "B" + ANSI.reset + "C" 
      end
      
      it "should replace ansi c as well as x" do
        AnsiFormatter.format("A%crB%CnC").should eq "A" + ANSI.red + "B" + ANSI.reset + "C" 
      end
      
      it "should replace nested codes" do
        AnsiFormatter.format("A%xc%xGB%xnC").should eq "A" + ANSI.cyan + ANSI.on_green + "B" + ANSI.reset + "C" 
      end

      it "should not replace a code preceeded by a backslash" do
        AnsiFormatter.format("A\\%xcB").should eq "A\\%xcB" 
      end
    end
  end
end