module AresMUSH
  module Website
    class WebhookRequestHandler
      def handle(request)
        
        if (request.args['cmd'] == 'discord')
          handler = Channels::DiscordWebhookHandler.new
          return handler.handle(request)
        else
          return Website.custom_webhooks(request)
        end
        
        {
        }
      end
    end
  end
end