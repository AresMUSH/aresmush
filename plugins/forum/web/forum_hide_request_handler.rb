module AresMUSH
  module Forum
    class ForumHideRequestHandler
      def handle(request)
                
        category_id = request.args[:category_id] 
        hide = request.args[:hide]
        enactor = request.enactor
        
        category = BbsBoard[category_id.to_i]
        if (!category)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (!Forum.can_read_category?(enactor, category))
          return { error: t('forum.cannot_access_category') }
        end

        prefs = Forum.get_forum_prefs(enactor, category)
        if (!prefs)
          prefs = BbsPrefs.create(bbs_board: category, character: enactor)
        end
        prefs.update(hidden: hide)
        
         {
         }
      end
    end
  end
end