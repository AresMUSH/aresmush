$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  # Too much of a pain to test in isolation, so these are more of integration tests
  # with real Liquid templates.
  describe TemplateFormatters do
    class TestFormatterData
      include TemplateFormatters
    end
    
    before do 
      @data = TestFormatterData.new
      Line.stub(:show) { "" }
    end
    
    describe :right do
      it "should right justify a string" do
        renderer = TemplateRenderer.new("<%= right(\"FOO\", 5) %>")
        renderer.render(@data).should eq "  FOO"
      end
      it "should trim a string that's too long" do
        renderer = TemplateRenderer.new("<%= right(\"FOOBAR\", 5) %>")
        renderer.render(@data).should eq "FOOBA"
      end
    end
  
    describe :left do
      it "should left justify a string" do
        renderer = TemplateRenderer.new("<%= left(\"FOO\", 5) %>")
        renderer.render(@data).should eq "FOO  "
      end
      it "should trim a string that's too long" do
        renderer = TemplateRenderer.new("<%= left(\"FOOBAR\", 5) %>")
        renderer.render(@data).should eq "FOOBA"
      end
    end
  
    describe :center do
      it "should center a string" do
        renderer = TemplateRenderer.new("<%= center(\"FOO\", 5) %>")
        renderer.render(@data).should eq " FOO "
      end
      it "should trim a string that's too long" do
        renderer = TemplateRenderer.new("<%= center(\"FOOBAR\", 5) %>")
        renderer.render(@data).should eq "FOOBA"
      end
    end
    
    describe :line do
      it "should default to line1" do
        renderer = TemplateRenderer.new("FOO <% line %>")
        renderer.render(@data).should eq "FOO %l1"
      end

      it "should accept a line option" do
        renderer = TemplateRenderer.new("FOO <% line(\"ABC\") %>")
        renderer.render(@data).should eq "FOO %lABC"
      end
    end
    
    describe :one_line do
      it "should squish newlines" do
        renderer = TemplateRenderer.new("<% one_line do %>FOO\n\nBAR<% end %>")
        renderer.render(@data).should eq "FOOBAR"
      end

      it "should end with a new line if it had one" do
        renderer = TemplateRenderer.new("<% one_line do %>FOO\n\nBAR<% end %>\n")
        renderer.render(@data).should match /\n$/
        renderer = TemplateRenderer.new("<% one_line do %>FOO\n\nBAR<% end %>")
        renderer.render(@data).should_not match /\n$/
      end
    end
  end
end
