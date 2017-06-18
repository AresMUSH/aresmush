$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe SubstitutionFormatter do
    before do
      Line.stub(:show) { "" }
    end
    
    describe :perform_subs do
      before do
        @enactor = { "name" => "Bob" }
      end

      it "should replace %r and %R with linebreaks" do
        SubstitutionFormatter.format("Test%rline%Rline2").should eq "Test\nline\nline2"
      end
      
      it "should replace %b and %B with blank space" do
        SubstitutionFormatter.format("Test%bblank%Bspace").should eq "Test blank space"
      end

      it "should replace %t and %T with 5 spaces" do
        SubstitutionFormatter.format("Test%tTest2%TTest3").should eq "Test     Test2     Test3"
      end

      it "should replace %lh with header" do
        Line.stub(:show).with("h") { "---" }
        SubstitutionFormatter.format("Test%lhTest").should eq "Test---Test"
      end    

      it "should replace %lf with footer" do
        Line.stub(:show).with("f") { "---" }
        SubstitutionFormatter.format("Test%lfTest").should eq "Test---Test"
      end    

      it "should replace %ld with divider" do
        Line.stub(:show).with("d") { "---" }
        SubstitutionFormatter.format("Test%ldTest").should eq "Test---Test"
      end    

      it "should replace %lp with plain line" do
        Line.stub(:show).with("p") { "---" }
        SubstitutionFormatter.format("Test%lpTest").should eq "Test---Test"
      end  
      
      it "should replace %LP with plain line (case doesn't matter)" do
        Line.stub(:show).with("P") { "---" }
        SubstitutionFormatter.format("Test%LPTest").should eq "Test---Test"
      end    
      
      it "should replace %x! with a random color" do
        AresMUSH::RandomColorizer.should_receive(:random_color) { "b" }
        SubstitutionFormatter.format("A%x!B").should eq "A" + ANSI.blue + "B"
      end

      it "should replace %\\ with a \\" do
        SubstitutionFormatter.format("A%\\B").should eq "A\\B"
      end
      
      it "should replace space() with spaces" do
        SubstitutionFormatter.format("A[space(1)]B[space(10)]").should eq "A B          "
      end

      it "should replace center() with centered text" do
        SubstitutionFormatter.format("[center(A,5)]B").should eq "  A  B"
      end
      
      it "should replace center() with centered text with a padding char" do
        SubstitutionFormatter.format("[center(A,6,.)]B").should eq "..A...B"
      end

      it "should replace left() with left text with a padding char" do
        SubstitutionFormatter.format("[left(A,6,.)]B").should eq "A.....B"
      end

      it "should replace right() with right text with a padding char" do
        SubstitutionFormatter.format("[right(A,6,.)]B").should eq ".....AB"
      end
      
      it "should replace ansi() with ansi codes" do
        SubstitutionFormatter.format("[ansi(hcB,A)]").should eq ANSI.bold + ANSI.cyan + ANSI.on_blue + "A" + ANSI.reset
      end
      
      it "should not replace an escaped linebreak or space" do
        SubstitutionFormatter.format("Test\\%bblank\\%Rline").should eq "Test\\%bblank\\%Rline"
      end
      
      it "should replace nested codes" do
        SubstitutionFormatter.format("A%xc%xGB%xnC").should eq "A" + ANSI.cyan + ANSI.on_green + "B" + ANSI.reset + "C" 
      end

      it "should not replace a code preceeded by a backslash" do
        SubstitutionFormatter.format("A\\%xcB").should eq "A\\%xcB" 
      end
      
      it "should handle a numeric code for foreground" do
        SubstitutionFormatter.format("A%x102B").should eq "A\e[38;5;102mB" 
      end
      
      it "should handle a numeric code for background" do
        SubstitutionFormatter.format("A%C102B").should eq "A\e[48;5;102mB" 
      end
      
      it "should handle a color code followed by a number" do
        SubstitutionFormatter.format("A%Cg123B").should eq "A" + ANSI.green + "123B" 
      end
      
    end
    
    
    describe :center do
      it "should truncate if the string is too long" do
        SubstitutionFormatter.center("A%xc%xhGB%xnC", 2).should eq "A%xc%xhG%xnC"
      end
      
      it "should pad if the string is too short" do
        SubstitutionFormatter.center("A%xc%xhGB%xnC", 10, ".").should eq "...A%xc%xhGB%xnC..."
      end
    end      

    describe :left do
      it "should truncate if the string is too long" do
        SubstitutionFormatter.left("A%xc%xhGB%xnC", 2).should eq "A%xc%xhG%xnC"
      end
      
      it "should pad if the string is too short" do
        SubstitutionFormatter.left("A%xc%xhGB%xnC", 10, ".").should eq "A%xc%xhGB%xnC......"
      end
      
      it "should pad if the string is just right" do
        SubstitutionFormatter.left("%xrABC%xn", 3).should eq "%xrABC%xn"
      end
    end 

    describe :right do
      it "should truncate if the string is too long" do
        SubstitutionFormatter.right("A%xc%xhGB%xnC", 2).should eq "A%xc%xhG%xnC"
      end
      
      it "should pad if the string is too short" do
        SubstitutionFormatter.right("A%xc%xhGB%xnC", 10, ".").should eq "......A%xc%xhGB%xnC"
      end
    end 
            
    describe :truncate do 
      it "should truncate a string that's too long" do
        SubstitutionFormatter.truncate("A%xc%xhGB%xnC", 2).should eq "A%xc%xhG%xnC"
      end
      
      it "should do nothing for a string that's shorter than allowed" do
        SubstitutionFormatter.truncate("A%xc%xhGB%xnC", 20).should eq "A%xc%xhGB%xnC"
      end
    end
    
  end
end