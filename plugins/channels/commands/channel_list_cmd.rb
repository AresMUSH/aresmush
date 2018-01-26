module AresMUSH
  module Channels
    class ChannelListCmd
      include CommandHandler
      include TemplateFormatters
      
      def handle   
        all_channels = Channel.all.sort_by(:name_upcase, :order => 'ALPHA')
        template = ChannelListTemplate.new(all_channels, enactor)
        client.emit template.render
      end
    end
  end
end
