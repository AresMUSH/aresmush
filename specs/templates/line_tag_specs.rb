$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe LineTag do
    before do
      TagExtensions.register
    end

    describe :render do
      it "should default to line1" do
        renderer = TemplateRenderer.new("FOO {% line %}")
        renderer.render({}).should eq "FOO %l1"
      end

      it "should accept a line option" do
        renderer = TemplateRenderer.new("FOO {% line ABC %}")
        renderer.render({}).should eq "FOO %lABC"
      end
    end
  end
end