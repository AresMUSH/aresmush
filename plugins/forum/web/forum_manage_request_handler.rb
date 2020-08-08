module AresMUSH
  module Forum
    class ManageForumRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Forum.can_manage_forum?(enactor)
        
        categories = BbsBoard.all.to_a.sort_by { |c| [ c.order, c.name ] }.map { |c|
          {
            id: c.id,
            name: c.name,
            order: c.order,
            desc: Website.format_markdown_for_html(c.description),
            can_read: c.read_roles.map { |r| r.name },
            can_write: c.write_roles.map { |r| r.name }
          }}
          
          {
            categories: categories,
            roles: Role.all.to_a.sort_by { |r| r.name }.map { |r| r.name }
          }
      end
    end
  end
end


