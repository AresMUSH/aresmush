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
    
    describe :strip_ansi do
      it "should replace ansi codes" do
        AnsiFormatter.strip_ansi("A%xrB%XnC").should eq "ABC"
      end
      
      it "should replace ansi c as well as x" do
        AnsiFormatter.strip_ansi("A%crB%CnC").should eq "ABC"
      end
      
      it "should replace nested codes" do
        AnsiFormatter.strip_ansi("A%xc%xGB%xnC").should eq "ABC"
      end

      it "should not replace a code preceeded by a backslash" do
        AnsiFormatter.strip_ansi("A\\%xcB").should eq "A\\%xcB" 
      end
    end    
    
    describe :center do
      it "should truncate if the string is too long" do
        AnsiFormatter.center("A%xc%xhGB%xnC", 2).should eq "A%xc%xhG%xn"
      end
      
      it "should pad if the string is too short" do
        AnsiFormatter.center("A%xc%xhGB%xnC", 10, ".").should eq "...A%xc%xhGB%xnC..."
      end
    end      

    describe :left do
      it "should truncate if the string is too long" do
        AnsiFormatter.left("A%xc%xhGB%xnC", 2).should eq "A%xc%xhG%xn"
      end
      
      it "should pad if the string is too short" do
        AnsiFormatter.left("A%xc%xhGB%xnC", 10, ".").should eq "A%xc%xhGB%xnC......"
      end
    end 

    describe :right do
      it "should truncate if the string is too long" do
        AnsiFormatter.right("A%xc%xhGB%xnC", 2).should eq "A%xc%xhG%xn"
      end
      
      it "should pad if the string is too short" do
        AnsiFormatter.right("A%xc%xhGB%xnC", 10, ".").should eq "......A%xc%xhGB%xnC"
      end
    end 
            
    describe :truncate do 
      it "should truncate a string that's too long" do
        AnsiFormatter.truncate("A%xc%xhGB%xnC", 2).should eq "A%xc%xhG%xn"
      end
      
      it "should do nothing for a string that's shorter than allowed" do
        AnsiFormatter.truncate("A%xc%xhGB%xnC", 20).should eq "A%xc%xhGB%xnC"
      end
    end
  end
end