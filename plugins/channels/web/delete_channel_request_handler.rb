module AresMUSH
  module Channels
    class DeleteChannelRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Channels.can_manage_channels?(enactor)

        channel = Channel[id]
        return { error: t('webportal.not_found') } if !channel
        
        Global.logger.info "Channel #{channel.name} deleted by #{enactor.name}."
        Channels.emit_to_channel channel, t('channels.channel_being_deleted', :name => enactor.name)
        channel.delete
                  
        {}
      end
    end
  end
end


