module AresMUSH
  module Sheet
    mattr_accessor :sheet_renderers
        
    def self.build_renderers
      self.sheet_renderers = [ SheetPage1Renderer.new, 
        SheetPage2Renderer.new, 
        SheetPage3Renderer.new ]
    end
      
    class SheetPage1Renderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/sheet1.erb")
      end
      
      def render(char)
        data = SheetPage1Template.new(char)
        @renderer.render(data)
      end
    end
    
    class SheetPage2Renderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/sheet2.erb")
      end
      
      def render(char)
        data = SheetPage2Template.new(char)
        @renderer.render(data)
      end
    end
    
    class SheetPage3Renderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/sheet3.erb")
      end
      
      def render(char)
        data = SheetPage3Template.new(char)
        @renderer.render(data)
      end
    end
  end
end