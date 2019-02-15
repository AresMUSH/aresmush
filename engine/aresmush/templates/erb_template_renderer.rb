module AresMUSH  
  class ErbTemplateRenderer
    include TemplateFormatters
    
    attr_accessor :client

    def initialize(file)
      template = File.read(file)
      @template = Erubis::Eruby.new(template, :bufvar=>'@output', :encoding => "UTF-8")
    end
      		      
    def render
      if (!@template)
        raise "Template file not found."
      end
      @template.evaluate(self)
    end		
    
    def render_local(locals)
      if (!@template)
        raise "Template file not found."
      end
      @template.evaluate(locals)
    end    
  end
end