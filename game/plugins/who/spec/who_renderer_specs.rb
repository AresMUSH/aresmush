require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoRenderer do
      before do
        @client1 = double(Client)
        @client2 = double(Client)
        @clients = [@client1, @client2]
      end

      describe :render do
        it "should string together the three component formats" do
          WhoRenderer.should_receive(:build_header).with(@clients) { "HEADER"}
          WhoRenderer.should_receive(:build_chars).with(@clients) { "CHARS" }
          WhoRenderer.should_receive(:build_footer).with(@clients) { "FOOTER" }
          WhoRenderer.render(@clients).should eq "HEADER\nCHARS\nFOOTER"
        end
      end

      describe :build_header do
        before do
          @renderer = double(WhoHeader).as_null_object
          WhoRendererFactory.stub(:build_header) { @renderer }
        end

        it "should build a header renderer" do          
          WhoRendererFactory.should_receive(:build_header).with(@clients) { @renderer }
          WhoRenderer.build_header(@clients)
        end

        it "should return the rendered output" do
          @renderer.should_receive(:render) { "ABC" }
          WhoRenderer.build_header(@clients).should eq "ABC"
        end
      end
      
      describe :build_footer do
        before do
          @renderer = double(WhoFooter).as_null_object
          WhoRendererFactory.stub(:build_footer) { @renderer }
        end

        it "should build a footer renderer" do          
          WhoRendererFactory.should_receive(:build_footer).with(@clients) { @renderer }
          WhoRenderer.build_footer(@clients)
        end

        it "should return the rendered output" do
          @renderer.should_receive(:render) { "ABC" }
          WhoRenderer.build_footer(@clients).should eq "ABC"
        end
      end
      
      describe :build_chars do
        before do
          @renderer1 = double(WhoChar).as_null_object
          @renderer2 = double(WhoChar).as_null_object
          WhoRendererFactory.stub(:build_char).with(@client1) { @renderer1 }
          WhoRendererFactory.stub(:build_char).with(@client2) { @renderer2 }
        end

        it "should build a renderer for each char" do
          WhoRendererFactory.should_receive(:build_char).with(@client1) { @renderer1 }
          WhoRendererFactory.should_receive(:build_char).with(@client2) { @renderer2 }
          WhoRenderer.build_chars(@clients)
        end

        it "should return the rendered output" do
          @renderer1.should_receive(:render) { "ABC-" }
          @renderer2.should_receive(:render) { "DEF" }
          WhoRenderer.build_chars(@clients).should eq "ABC-DEF"
        end
      end
    end
  end
end