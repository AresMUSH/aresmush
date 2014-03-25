$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe TemplateRenderer do
    describe :render do
      it "should render the erubis template" do
        template = double        
        data = double        
        Erubis::Eruby.stub(:new) { template }
        template.should_receive(:evaluate).with(data)
        renderer = TemplateRenderer.new("TEST")
        renderer.render(data)        
      end
      
      it "should return empty string for nil data" do
        renderer = TemplateRenderer.new("TEST {{foo}}")
        renderer.render(nil).should eq ""
      end
      
      it "should be able to render an object" do
        data = double
        data.stub(:foo) { "FOO" }
        renderer = TemplateRenderer.new("TEST <%= foo %>")
        renderer.render(data).should eq "TEST FOO"
      end
    end
    
    describe :initialize do
      it "should parse the template" do
        template = double   
        Erubis::Eruby.should_receive(:new).with("TEST", :bufvar=>'@output') { template }
        renderer = TemplateRenderer.new("TEST")
      end
    end
  end
end
