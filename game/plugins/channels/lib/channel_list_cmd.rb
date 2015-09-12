module AresMUSH
  module Channels
    class ChannelListCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      include TemplateFormatters
           
      def want_command?(client, cmd)
        cmd.root_is?("channel") && (cmd.switch_is?("list") || !cmd.switch)
      end
      
      def handle        
        all_channels = Channel.all.sort { |c1, c2| c1.name <=> c2.name }
        template = ChannelListTemplate.new(all_channels, client)
        template.render
      end
    end
  end
end
