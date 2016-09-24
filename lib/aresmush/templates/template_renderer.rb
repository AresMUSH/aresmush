module AresMUSH  
  class ErbTemplateRenderer
    attr_accessor :client

    def initialize(file)
      template = File.read(file)
      @template = Erubis::Eruby.new(template, :bufvar=>'@output')
    end
      		      
    def render
      @template.evaluate(self)
    end		    
  end
end