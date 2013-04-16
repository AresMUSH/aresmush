require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoRenderer do
      before do
        @container = mock(Container)
        @client1 = mock(Client)
        @client2 = mock(Client)
        @clients = [@client1, @client2]
      end

      describe :render do
        it "should string together the three component formats" do
          WhoRenderer.should_receive(:build_header).with(@clients, @container) { "HEADER"}
          WhoRenderer.should_receive(:build_chars).with(@clients, @container) { "CHARS" }
          WhoRenderer.should_receive(:build_footer).with(@clients, @container) { "FOOTER" }
          WhoRenderer.render(@clients, @container).should eq "HEADER\nCHARS\nFOOTER"
        end
      end

      describe :build_header do
        before do
          @renderer = mock(WhoHeader).as_null_object
          WhoRendererFactory.stub(:build_header) { @renderer }
        end

        it "should build a header renderer" do          
          WhoRendererFactory.should_receive(:build_header).with(@clients, @container) { @renderer }
          WhoRenderer.build_header(@clients, @container)
        end

        it "should return the rendered output" do
          @renderer.should_receive(:render) { "ABC" }
          WhoRenderer.build_header(@clients, @container).should eq "ABC"
        end
      end
      
      describe :build_footer do
        before do
          @renderer = mock(WhoFooter).as_null_object
          WhoRendererFactory.stub(:build_footer) { @renderer }
        end

        it "should build a footer renderer" do          
          WhoRendererFactory.should_receive(:build_footer).with(@clients, @container) { @renderer }
          WhoRenderer.build_footer(@clients, @container)
        end

        it "should return the rendered output" do
          @renderer.should_receive(:render) { "ABC" }
          WhoRenderer.build_footer(@clients, @container).should eq "ABC"
        end
      end
      
      describe :build_chars do
        before do
          @renderer1 = mock(WhoChar).as_null_object
          @renderer2 = mock(WhoChar).as_null_object
          WhoRendererFactory.stub(:build_char).with(@client1, @container) { @renderer1 }
          WhoRendererFactory.stub(:build_char).with(@client2, @container) { @renderer2 }
        end

        it "should build a renderer for each char" do
          WhoRendererFactory.should_receive(:build_char).with(@client1, @container) { @renderer1 }
          WhoRendererFactory.should_receive(:build_char).with(@client2, @container) { @renderer2 }
          WhoRenderer.build_chars(@clients, @container)
        end

        it "should return the rendered output" do
          @renderer1.should_receive(:render) { "ABC-" }
          @renderer2.should_receive(:render) { "DEF" }
          WhoRenderer.build_chars(@clients, @container).should eq "ABC-DEF"
        end
      end
    end
  end
end