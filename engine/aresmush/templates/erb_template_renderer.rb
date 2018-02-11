module AresMUSH  
  class ErbTemplateRenderer
    include TemplateFormatters
    
    attr_accessor :client

    def initialize(file)
      template = File.read(file)
      @template = Erubis::Eruby.new(template, :bufvar=>'@output', :encoding => "UTF-8")
    end
      		      
    def render
      @template.evaluate(self)
    end		
    
    def render_local(locals)
      @template.evaluate(locals)
    end    
  end
end