module AresMUSH
  module Channels
    class ChannelListCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      include TemplateFormatters           
      
      def handle        
        all_channels = Channel.all.sort { |c1, c2| c1.name <=> c2.name }
        template = ChannelListTemplate.new(all_channels, client)
        template.render
      end
    end
  end
end
