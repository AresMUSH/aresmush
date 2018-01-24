module AresMUSH  
  class HandlebarsTemplate
    def initialize(file)
      template = File.read(file)
      @handlebars = Handlebars::Context.new
      template_contents = File.read(file)
      @template = @handlebars.compile(template_contents)
      
      
    end
      		      
    def render(data)
      @template.call(data)
    end		
  end
end