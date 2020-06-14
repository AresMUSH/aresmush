module AresMUSH
  module Channels
    class EditChannelRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Channels.can_manage_channels?(enactor)

        channel = Channel[id]
        return { error: t('webportal.not_found') } if !channel
        
          {
            channel: {
              id: channel.id,
              name: channel.name,
              color: channel.color,
              desc: Website.format_input_for_html(channel.description),
              can_join: channel.join_roles.map { |r| r.name },
              can_talk: channel.talk_roles.map { |r| r.name }
            },
            roles: Role.all.to_a.sort_by { |r| r.name }.map { |r| r.name }
          }
      end
    end
  end
end


