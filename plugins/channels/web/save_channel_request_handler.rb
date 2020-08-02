module AresMUSH
  module Channels
    class SaveChannelRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        name = request.args[:name]
        color = request.args[:color]
        desc = request.args[:desc]
        can_join = request.args[:can_join] || []
        can_talk = request.args[:can_talk] || []
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Channels.can_manage_channels?(enactor)

        channel = Channel[id]
        return { error: t('webportal.not_found') } if !channel
        
        if (name.blank?)
          return { error: t('channels.name_required')}      
        end
        
        other_channel = Channel.named(name)
        if (other_channel && other_channel != channel)
          return { error: t('channels.channel_already_exists', :name => name) }
        end
        
        if (color.blank?)
          color = "%xh"
        end
        
        channel.set_roles(can_join, :join)
        channel.set_roles(can_talk, :talk)
        
        channel.update(name: name, color: color, description: desc ? Website.format_input_for_mush(desc) : "")
        
        channel.characters.each do |c|
          if (!Channels.can_join_channel?(c, channel))
            Channels.leave_channel(c, channel)
          end
        end
                  
        {}
      end
    end
  end
end


