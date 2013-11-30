$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe StripTag do
    before do
      TagExtensions.register
    end

    describe :render do
      it "should strip double newlines" do
        renderer = TemplateRenderer.new("{% strip %}FOO\n\nBAR{% endstrip %}")
        renderer.render({}).should eq "FOO\nBAR"
      end
    end
  end
end