module AresMUSH
  module Forum
    class SaveForumRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        name = request.args[:name]
        desc = request.args[:desc]
        order = request.args[:order] || ""
        can_read = request.args[:can_read] || []
        can_write = request.args[:can_write] || []
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Forum.can_manage_forum?(enactor)

        forum = BbsBoard[id]
        return { error: t('webportal.not_found') } if !forum

        if (name.blank?)
          return { error: t('forum.name_required')}      
        end
                
        other_forum = BbsBoard.named(name)
        if (other_forum && other_forum != forum)
          return { error: t('forum.category_already_exists') }
        end
        
        approved_role = Role.find_one_by_name('approved')
        if (can_write.empty? && approved_role)
          can_write = [ "approved" ]
        end
        
        forum.set_roles(can_read, :read)
        forum.set_roles(can_write, :write)
        
        forum.update(name: name, description: Website.format_input_for_mush(desc), order: order.to_i)
        
        {}
      end
    end
  end
end


