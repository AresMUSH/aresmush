module AresMUSH
  module Channels
    class ChannelWhoCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :name

      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
            
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          online_chars = Channels.channel_who(channel)
          names = online_chars.map { |c| "#{Handles::Api.ooc_name(c)}#{Channels.gag_text(c, channel)}" }
          text = t('channels.channel_who', :name => channel.display_name, :chars => names.join(", "))
          
          client.emit_ooc "%xn#{text}"
        end
      end
    end  
  end
end