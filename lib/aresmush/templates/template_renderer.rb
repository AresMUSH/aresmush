module AresMUSH  
  class TemplateRenderer
    def initialize(template)
      @template = Erubis::Eruby.new(template, :bufvar=>'@output')
    end
    
    def render(data)
      return "" if data.nil?
      @template.evaluate(data)
    end
    
    def self.create_from_file(file_path)
      template = File.read(file_path)
      TemplateRenderer.new(template)
    end
  end
end