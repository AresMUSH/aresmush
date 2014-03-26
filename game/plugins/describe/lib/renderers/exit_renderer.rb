module AresMUSH
  module Describe
    class ExitRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/exit.erb")
      end
      
      def render(model)
        data = ExitTemplate.new(model)
        @renderer.render(data)
      end
    end
  end
end