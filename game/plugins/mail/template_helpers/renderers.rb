module AresMUSH
  module Mail
    
    mattr_accessor :inbox_renderer, :message_renderer, :forwarded_renderer
        
    def self.build_renderers
        self.inbox_renderer = InboxRenderer.new
        self.message_renderer = MessageRenderer.new
        self.forwarded_renderer = ForwardedRenderer.new
    end
    
    class InboxRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/inbox.erb")
      end
      
      def render(client, messages, show_from, title)
        data = InboxTemplate.new(client, messages, show_from, title)
        @renderer.render(data)
      end
    end

    class MessageRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/message.erb")
      end
      
      def render(client, delivery)
        data = MessageTemplate.new(client, delivery)
        @renderer.render(data)
      end
    end
    
    class ForwardedRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/forwarded.erb")
      end
      
      def render(client, original, comment)
        data = ForwardedTemplate.new(client.char, original, comment)
        @renderer.render(data)
      end
    end    
    
  end
end