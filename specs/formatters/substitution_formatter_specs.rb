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

      it "should replace %l1 with line1" do
        Line.stub(:show).with("1") { "---" }
        SubstitutionFormatter.format("Test%l1Test").should eq "Test---Test"
      end    

      it "should replace %l2 with line2" do
        Line.stub(:show).with("2") { "---" }
        SubstitutionFormatter.format("Test%l2Test").should eq "Test---Test"
      end    

      it "should replace %l3 with line3" do
        Line.stub(:show).with("3") { "---" }
        SubstitutionFormatter.format("Test%l3Test").should eq "Test---Test"
      end    

      it "should replace %l4 with line4" do
        Line.stub(:show).with("4") { "---" }
        SubstitutionFormatter.format("Test%l4Test").should eq "Test---Test"
      end    
      
      it "should replace %x! with a random color" do
        AresMUSH::RandomColorizer.should_receive(:random_color) { "b" }
        SubstitutionFormatter.format("A%x!B").should eq "A%xbB"
      end

      it "should replace space() with spaces" do
        SubstitutionFormatter.format("A[space(1)]B[space(10)]").should eq "A%BB%B%B%B%B%B%B%B%B%B%B"
      end
      
      it "should not replace escaped space()" do
        SubstitutionFormatter.format("A[space(1)]B\\[space(10)]").should eq "A%BB\\[space(10)]"
      end
    end
    
  end
end