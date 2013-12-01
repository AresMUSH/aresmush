module AresMUSH  
  class TemplateRenderer
    def initialize(template)
      @template = Liquid::Template.parse(template)
    end
    
    def render(data)
      return "" if data.nil?
      if (data.respond_to?(:to_liquid))
        @template.render(data.to_liquid)
      else
        @template.render(data)
      end
    end
    
    def self.create_from_file(file_path)
      template = File.read(file_path)
      TemplateRenderer.new(template)
    end
  end
end