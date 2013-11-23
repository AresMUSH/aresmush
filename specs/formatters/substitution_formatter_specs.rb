$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe SubstitutionFormatter do
    before do
      @config_reader = double
      @config_reader.stub(:line) { "" }
    end
    
    describe :perform_subs do
      before do
        @enactor = { "name" => "Bob" }
      end

      it "should replace %r and %R with linebreaks" do
        SubstitutionFormatter.format("Test%rline%Rline2", @config_reader).should eq "Test\nline\nline2"
      end

      it "should replace %t and %T with 5 spaces" do
        SubstitutionFormatter.format("Test%tTest2%TTest3", @config_reader).should eq "Test     Test2     Test3"
      end

      it "should replace %~ with the unicode marker" do
        SubstitutionFormatter.format("Test%~Test", @config_reader).should eq "Test\u2682Test"
      end  
      
      it "should replace %l1 with line1" do
        @config_reader.stub(:line).with("1") { "---" }
        SubstitutionFormatter.format("Test%l1Test", @config_reader).should eq "Test---Test"
      end    

      it "should replace %l2 with line2" do
        @config_reader.stub(:line).with("2") { "---" }
        SubstitutionFormatter.format("Test%l2Test", @config_reader).should eq "Test---Test"
      end    

      it "should replace %l3 with line3" do
        @config_reader.stub(:line).with("3") { "---" }
        SubstitutionFormatter.format("Test%l3Test", @config_reader).should eq "Test---Test"
      end    

      it "should replace %l4 with line4" do
        @config_reader.stub(:line).with("4") { "---" }
        SubstitutionFormatter.format("Test%l4Test", @config_reader).should eq "Test---Test"
      end    
      
      it "should replace %x! with a random color" do
        AresMUSH::RandomColorizer.should_receive(:random_color) { "b" }
        SubstitutionFormatter.format("A%x!B", @config_reader).should eq "A%xbB"
      end

    end
    
  end
end