$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe SquishTag do
    before do
      TagExtensions.register
    end

    describe :render do
      it "should squish newlines" do
        renderer = TemplateRenderer.new("{% squish %}FOO\n\nBAR{% endsquish %}")
        renderer.render({}).should eq "FOOBAR"
      end
    end
  end
end