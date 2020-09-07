module AresMUSH
  module Channels
    class ManageChatRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Channels.can_manage_channels?(enactor)
        
        channels = Channel.all.to_a.sort_by { |c| c.name }.map { |c|
          {
            id: c.id,
            name: c.name,
            color: c.color,
            desc: Website.format_markdown_for_html(c.description),
            can_join: c.join_roles.map { |r| r.name },
            can_talk: c.talk_roles.map { |r| r.name }
          }}
          
          {
            channels: channels,
            roles: Role.all.to_a.sort_by { |r| r.name }.map { |r| r.name }
          }
      end
    end
  end
end


