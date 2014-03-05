module AresMUSH
  describe BorderedDisplay do
    describe :list do
      it "should display items one per line" do
        expected_result = "%ra%rb"
        BorderedDisplay.should_receive(:text).with(expected_result, "Foo") { expected_result }
        output = BorderedDisplay.list([ "a", "b" ], "Foo")
        output.should eq expected_result
      end
    end
    
    describe :table do
      it "should display items several per line" do
        expected_result = "%ra                        " + 
        "b                        c                        %rd                        " +
        "e                        f                        "
        items = [ "a", "b", "c", "d", "e", "f" ].map { |i| i.ljust(30) }
        BorderedDisplay.should_receive(:text).with(expected_result, "Foo") { expected_result }
        output = BorderedDisplay.table(items, 25, "Foo")
        output.should eq expected_result
      end
    end
    
    describe :text do
      it "should allow the title to be optional" do
        output = BorderedDisplay.text("TEXT")
        output.should eq "%l1TEXT%r%l1"
      end
      
      it "should border the text and title with lines" do
        output = BorderedDisplay.text("TEXT", "TITLE")
        output.should eq "%l1%r%xhTITLE%xnTEXT%r%l1"
      end
    end
  end
end