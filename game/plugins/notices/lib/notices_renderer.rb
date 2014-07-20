module AresMUSH
  module Notices
    
    mattr_accessor :notices_renderer
        
    def self.build_renderers
        self.notices_renderer = NoticesRenderer.new
    end
    
    class NoticesRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/notices.erb")
      end

      def render(client)
        data = NoticesTemplate.new(client.char)
        @renderer.render(data)
      end
    end
  end
end