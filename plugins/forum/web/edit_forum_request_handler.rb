module AresMUSH
  module Forum
    class EditForumRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Forum.can_manage_forum?(enactor)

        forum = BbsBoard[id]
        return { error: t('webportal.not_found') } if !forum
        
          {
            category: {
              id: forum.id,
              name: forum.name,
              order: forum.order,
              desc: Website.format_input_for_html(forum.description),
              can_read: forum.read_roles.map { |r| r.name },
              can_write: forum.write_roles.map { |r| r.name }
            },
            roles: Role.all.to_a.sort_by { |r| r.name }.map { |r| r.name }
          }
      end
    end
  end
end


