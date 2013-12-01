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
      
      it "should return empty string for nil data" do
        renderer = TemplateRenderer.new("TEST {{foo}}")
        renderer.render(nil).should eq ""
      end
      
      it "should be able to render a hash" do
        renderer = TemplateRenderer.new("TEST {{foo}}")
        renderer.render({ "foo" => "FOO" }).should eq "TEST FOO"
      end
      
      it "should be able to render an object that implements to_liquid" do
        data = double
        data.stub(:respond_to?).with(:to_liquid) { true }
        data.should_receive(:to_liquid) { { "foo" => "FOO" }}
        renderer = TemplateRenderer.new("TEST {{foo}}")
        renderer.render(data).should eq "TEST FOO"
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
