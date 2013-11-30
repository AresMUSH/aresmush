$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  # Too much of a pain to test in isolation, so these are more of integration tests
  # with real Liquid templates.
  describe RightTag do
    before do
      TagExtensions.register
    end
    
    describe :render do
      it "should right justify a string" do
        renderer = TemplateRenderer.new("{% right 5 %}FOO{% endright %}")
        renderer.render({}).should eq "  FOO"
      end
      it "should trim a string that's too long" do
        renderer = TemplateRenderer.new("{% right 5 %}FOOBAR{% endright %}")
        renderer.render({}).should eq "FOOBA"
      end
    end
  end

  describe LeftTag do
    before do
      TagExtensions.register
    end

    describe :render do
      it "should left justify a string" do
        renderer = TemplateRenderer.new("{% left 5 %}FOO{% endleft %}")
        renderer.render({}).should eq "FOO  "
      end
      it "should trim a string that's too long" do
        renderer = TemplateRenderer.new("{% left 5 %}FOOBAR{% endleft %}")
        renderer.render({}).should eq "FOOBA"
      end
    end
  end

  describe CenterTag do
    before do
      TagExtensions.register
    end

    describe :render do
      it "should center a string" do
        renderer = TemplateRenderer.new("{% center 5 %}FOO{% endcenter %}")
        renderer.render({}).should eq " FOO "
      end
      it "should trim a string that's too long" do
        renderer = TemplateRenderer.new("{% center 5 %}FOOBAR{% endcenter %}")
        renderer.render({}).should eq "FOOBA"
      end
    end
  end
end
