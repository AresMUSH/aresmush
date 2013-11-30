$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe TemplateRenderer do
    describe :render do
      it "should render the liquid template" do
        template = double        
        data = double        
        Liquid::Template.stub(:parse) { template }
        template.should_receive(:render).with(data)
        renderer = TemplateRenderer.new("TEST")
        renderer.render(data)        
      end
    end
    
    describe :initialize do
      it "should parse the liquid template" do
        template = double        
        Liquid::Template.should_receive(:parse).with("TEST") { template }
        renderer = TemplateRenderer.new("TEST")
      end
    end
  end
end
