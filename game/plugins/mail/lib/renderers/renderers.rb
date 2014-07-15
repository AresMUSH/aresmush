module AresMUSH
  module Mail
    module RendererFactory
      def self.inbox_renderer=(renderer)
        @@inbox_renderer = renderer
      end
    
      def self.inbox_renderer
        @@inbox_renderer
      end
    
      def self.message_renderer=(renderer)
        @@message_renderer = renderer
      end
    
      def self.message_renderer
        @@message_renderer
      end
    
      def self.forwarded_renderer=(renderer)
        @@forwarded_renderer = renderer
      end
    
      def self.forwarded_renderer
        @@forwarded_renderer
      end
      
      def self.build_renderers
        self.inbox_renderer = InboxRenderer.new
        self.message_renderer = MessageRenderer.new
        self.forwarded_renderer = ForwardedRenderer.new
      end
    end
    
    class InboxRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/inbox.erb")
      end
      
      def render(client)
        messages = client.char.mail.map { |m| InboxMessageTemplate.new(client.char, m) }
        data = InboxTemplate.new(client.char, messages)
        @renderer.render(data)
      end
    end

    class MessageRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/message.erb")
      end
      
      def render(client, delivery)
        data = MessageTemplate.new(client.char, delivery)
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