module AresMUSH
  module Channels
    class CreateChannelRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        color = request.args[:color]
        desc = request.args[:desc]
        can_join = request.args[:can_join] || []
        can_talk = request.args[:can_talk] || []
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Channels.can_manage_channels?(enactor)

        if (name.blank?)
          return { error: t('channels.name_required')}      
        end
        
        other_channel = Channel.named(name)
        if (other_channel)
          return { error: t('channels.channel_already_exists', :name => name) }
        end
        
        if (color.blank?)
          color = "%xh"
        end
        
        Global.logger.info "Channel #{name} created by #{enactor.name}."
        
        channel = Channel.create(name: name, description: Website.format_input_for_mush(desc), color: color)
        channel.set_roles(can_join, :join)
        channel.set_roles(can_talk, :talk)

        {}
      end
    end
  end
end


