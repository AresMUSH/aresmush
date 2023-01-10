module AresMUSH  
  mattr_accessor :handlebars_context
  
  class HandlebarsTemplate
    def initialize(file)
      template = File.read(file)
      if (!AresMUSH.handlebars_context)
        AresMUSH.handlebars_context = Handlebars::Engine.new
      end
      @handlebars = AresMUSH.handlebars_context
      template_contents = File.read(file)
            
      @template = @handlebars.compile(template_contents)
      
      
    end
      		      
    def render(data)      
      @template.call(data)
    end		
  end
end