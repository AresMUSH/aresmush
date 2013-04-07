$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  class TestRenderer < TemplateRenderer
    def foo
      "foo"
    end  

    attr_accessor :data
    attr_accessor :template
  end


  describe TemplateRenderer do
    before do
      @renderer = TestRenderer.new
      @data = mock
      @renderer.data = @data
    end

    describe :render do
      it "should call a field method on the object itself" do
        @renderer.template = 
        [
          {
            "field" => "foo"
          }
        ]
        @data.should_not_receive(:foo)
        @renderer.render.should eq "foo"
      end

      it "should pass an unhandled field onto the data object" do
        @renderer.template = 
        [
          {
            "field" => "bar"
          }
        ]
        @data.should_receive(:bar) { "bar" }
        @renderer.render.should eq "bar"
      end

      it "should string multiple fields together" do
        @renderer.template = 
        [
          { "field" => "foo" },
          { "field" => "bar" },
          { "field" => "baz" },
        ]
        @data.should_receive(:bar) { "bar" }
        @data.should_receive(:baz) { "baz" }
        @renderer.render.should eq "foobarbaz"
      end

      it "should handle a raw text field" do
        @renderer.template = 
        [
          { "field" => "foo" },
          { "field" => "test", "type" => "text" },
        ]
        @renderer.render.should eq "footest"      
      end    
    end

    describe :format_field do
      it "should default to no justification" do
        config = {}
        @renderer.format_field("test", config).should eq "test"
      end
      
      it "should default to a width of 10" do
        config = { "justify" => "left" }
        @renderer.format_field("test", config).should eq "test      "
      end
      
      it "should default to a padding space" do
        config = { "justify" => "left", "width" => 5 }
        @renderer.format_field("test", config).should eq "test "
      end

      it "should justify right" do
        config = { "justify" => "right", "width" => 5 }
        @renderer.format_field("test", config).should eq " test"
      end

      it "should justify center" do
        config = { "justify" => "center", "width" => 6 }
        @renderer.format_field("test", config).should eq " test "
      end

      it "should justify with a padding char" do
        config = { "justify" => "right", "width" => 5, "padding" => "." }
        @renderer.format_field("test", config).should eq ".test"
      end
    end

  end
end
