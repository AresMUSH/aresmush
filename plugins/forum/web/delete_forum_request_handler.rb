module AresMUSH
  module Forum
    class DeleteForumRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Forum.can_manage_forum?(enactor)

        forum = BbsBoard[id]
        return { error: t('webportal.not_found') } if !forum
        
        Global.logger.info "Forum #{forum.name} deleted by #{enactor.name}."
        forum.delete
                  
        {}
      end
    end
  end
end


