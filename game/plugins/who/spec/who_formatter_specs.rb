require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoFormatter do
      before do
        @container = mock(Container)
        @client1 = mock(Client)
        @client2 = mock(Client)
        @clients = [@client1, @client2]
      end

      describe :format do
        it "should string together the three component formats" do
          WhoFormatter.should_receive(:build_header).with(@clients, @container) { "HEADER-"}
          WhoFormatter.should_receive(:build_chars).with(@clients, @container) { "CHARS-" }
          WhoFormatter.should_receive(:build_footer).with(@clients, @container) { "FOOTER" }
          WhoFormatter.format(@clients, @container).should eq "HEADER-CHARS-FOOTER"
        end
      end

      describe :build_header do
        before do
          @formatter = mock(WhoHeader).as_null_object
          WhoFormatterFactory.stub(:build_header) { @formatter }
        end

        it "should build a header formatter" do          
          WhoFormatterFactory.should_receive(:build_header).with(@clients, @container) { @formatter }
          WhoFormatter.build_header(@clients, @container)
        end

        it "should return the rendered output" do
          @formatter.should_receive(:render_default) { "ABC" }
          WhoFormatter.build_header(@clients, @container).should eq "ABC"
        end
      end
      
      describe :build_footer do
        before do
          @formatter = mock(WhoFooter).as_null_object
          WhoFormatterFactory.stub(:build_footer) { @formatter }
        end

        it "should build a footer formatter" do          
          WhoFormatterFactory.should_receive(:build_footer).with(@clients, @container) { @formatter }
          WhoFormatter.build_footer(@clients, @container)
        end

        it "should return the rendered output" do
          @formatter.should_receive(:render_default) { "ABC" }
          WhoFormatter.build_footer(@clients, @container).should eq "ABC"
        end
      end
      
      describe :build_chars do
        before do
          @formatter1 = mock(WhoChar).as_null_object
          @formatter2 = mock(WhoChar).as_null_object
          WhoFormatterFactory.stub(:build_char).with(@client1, @container) { @formatter1 }
          WhoFormatterFactory.stub(:build_char).with(@client2, @container) { @formatter2 }
        end

        it "should build a formatter for each char" do
          WhoFormatterFactory.should_receive(:build_char).with(@client1, @container) { @formatter1 }
          WhoFormatterFactory.should_receive(:build_char).with(@client2, @container) { @formatter2 }
          WhoFormatter.build_chars(@clients, @container)
        end

        it "should return the rendered output" do
          @formatter1.should_receive(:render_default) { "ABC-" }
          @formatter2.should_receive(:render_default) { "DEF" }
          WhoFormatter.build_chars(@clients, @container).should eq "ABC-DEF"
        end
      end
    end
  end
end