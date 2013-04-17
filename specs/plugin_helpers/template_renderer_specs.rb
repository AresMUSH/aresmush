$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  class TestRenderer < TemplateRenderer
    def foo
      "foo"
    end  
  end


  describe TemplateRenderer do
    before do
      @data = mock
      @renderer = TestRenderer.new([], @data)
      @renderer.data = @data
    end

    describe :render do
      it "should call a field method on the object itself" do
        @renderer.template = 
        [
          {
            "variable" => "foo"
          }
        ]
        @data.should_not_receive(:foo)
        @renderer.render.should eq "foo"
      end

      it "should pass an unhandled field onto the data object" do
        @renderer.template = 
        [
          {
            "variable" => "bar"
          }
        ]
        @data.should_receive(:bar) { "bar" }
        @renderer.render.should eq "bar"
      end

      it "should treat an unhandled field as text" do
        @renderer.template = 
        [
          {
            "variable" => "boo"
          }
        ]
        @renderer.render.should eq "boo"
      end

      it "should string multiple fields together" do
        @renderer.template = 
        [
          { "variable" => "foo" },
          { "variable" => "bar" },
          { "variable" => "baz" },
        ]
        @data.should_receive(:bar) { "bar" }
        @data.should_receive(:baz) { "baz" }
        @renderer.render.should eq "foobarbaz"
      end

      it "should respond to a raw text field wich funny characters" do
        @renderer.template = 
        [
          { "text" => "foo%rbar%l1" },
        ]
        @renderer.render.should eq "foo%rbar%l1"      
      end    

      it "should respond to nested field calls" do
        @renderer.template = 
        [
          { "variable" => "bar.baz" },
        ]
        bar = mock
        @data.should_receive(:bar) { bar }
        bar.should_receive(:baz) { "baz" }
        @renderer.render.should eq "baz"      
      end
      
      it "should respond to nested field calls to a non-existent param" do
        @renderer.template = 
        [
          { "variable" => "bar.baz" },
        ]
        bar = mock
        @data.should_receive(:bar) { bar }
        @renderer.render.should eq "baz"      
      end

      it "should respond to a line" do
        @renderer.template = 
        [
          { "line" => 2 },
        ]
        @renderer.render.should eq "%l2"      
      end

      it "should respond to a newline" do
        @renderer.template = 
        [
          { "new_line" => "" },
        ]
        @renderer.render.should eq "%r"      
      end

    end

    describe :recursive_send do
      it "should send recursively if methods are available" do
        bar = mock
        @data.should_receive(:bar) { bar }
        bar.should_receive(:baz) { "baz" }
        @renderer.recursive_send("bar.baz").should eq "baz"
      end

      it "should return the raw value when the end of a method chain is reached" do
        bar = mock
        baz = mock
        @data.should_receive(:bar) { bar }
        bar.should_receive(:baz) { baz }
        @renderer.recursive_send("bar.baz.foo").should eq "foo"
      end

    end

    describe :format_field do

      it "should default to the raw unadorned string" do
        config = {}
        @renderer.format_field("test", config).should eq "test"
      end

      describe :align_field do

        it "should default to the width of the string" do
          config = { "align" => "left" }
          @renderer.format_field("test", config).should eq "test"
        end

        it "should default to a padding space" do
          config = { "align" => "left", "width" => 5 }
          @renderer.format_field("test", config).should eq "test "
        end

        it "should align right" do
          config = { "align" => "right", "width" => 5 }
          @renderer.format_field("test", config).should eq " test"
        end

        it "should align center" do
          config = { "align" => "center", "width" => 6 }
          @renderer.format_field("test", config).should eq " test "
        end

        it "should align with a padding char" do
          config = { "align" => "right", "width" => 5, "padding" => "." }
          @renderer.format_field("test", config).should eq ".test"
        end
      end

      describe :color_field do
        it "should support color" do
          config = { "color" => "g" }
          @renderer.format_field("test", config).should eq "%xgtest%xn"
        end

        it "should support multiple colors" do
          config = { "color" => "hg" }
          @renderer.format_field("test", config).should eq "%xh%xgtest%xn"
        end
      end

      describe :trim_field do

        it "should trim a string to 1 less than pad width" do
          config = { "width" => "3" }
          @renderer.format_field("test", config).should eq "te"
        end

        it "should handle a string that's too short to trim" do
          config = { "width" => "10" }
          @renderer.format_field("test", config).should eq "test"
        end

      end
    end

  end
end
