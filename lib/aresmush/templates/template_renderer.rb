module AresMUSH  
  class TemplateRenderer
    def initialize(template)
      @template = Liquid::Template.parse(template)
    end
    
    def render(data)
      @template.render(data)
    end
  end
end