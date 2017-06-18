module AresMUSH
  describe BorderedDisplay do
    describe :list do
      it "should display items one per line" do
        expected_result = "%ra%rb"
        BorderedDisplay.should_receive(:text).with(expected_result, "Foo", false, nil) { expected_result }
        output = BorderedDisplay.list([ "a", "b" ], "Foo")
        output.should eq expected_result
      end
    end
    
    describe :paged_list do
      before do
        @title_line = "%xh------------------------------------title-------------------------------------%xn"
      end
      
      it "should show items when there is not a full page" do
        Locale.stub(:translate).with("pages.page_x_of_y", :x => 1, :y => 1) { "title" }
        BorderedDisplay.should_receive(:list).with(["a", "b"], "Foo",  @title_line) { "test" }
        output = BorderedDisplay.paged_list([ "a", "b" ], 1, 20, "Foo")
        output.should eq "test"
      end
      
      it "should show items when there is more than one page" do
        Locale.stub(:translate).with("pages.page_x_of_y", :x => 2, :y => 3) { "title" }
        BorderedDisplay.should_receive(:list).with(["c", "d"], "Foo",  @title_line) { "test" }
        output = BorderedDisplay.paged_list([ "a", "b", "c", "d", "e"], 2, 2, "Foo")
        output.should eq "test"
      end
      
      it "should display an error if beyond page boundary" do
        Locale.stub(:translate).with("pages.not_that_many_pages") { "not_that_many_pages" }
        BorderedDisplay.should_receive(:text).with("not_that_many_pages") { "test" }
        output = BorderedDisplay.paged_list([ "a", "b", "c", "d", "e"], 4, 2, "Foo")
        output.should eq "test"
      end
    end
    
    describe :table do
      it "should display items several per line" do
        expected_result = "%ra                        " + 
        "b                        c                        %rd                        " +
        "e                        f                        "
        items = [ "a", "b", "c", "d", "e", "f" ].map { |i| i.ljust(30) }
        BorderedDisplay.should_receive(:text).with(expected_result, "Foo", false) { expected_result }
        output = BorderedDisplay.table(items, 25, "Foo")
        output.should eq expected_result
      end
    end
    
    describe :text do
      it "should allow the title to be optional" do
        output = BorderedDisplay.text("TEXT")
        output.should eq "%lh%rTEXT%r%lf"
      end
      
      it "should border the text and title with lines" do
        output = BorderedDisplay.text("TEXT", "TITLE")
        output.should eq "%lh%r%xhTITLE%xn%r%rTEXT%r%lf"
      end
    end
  end
end