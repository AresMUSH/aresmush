module AresMUSH
  module Forum
    class ForumHideRequestHandler
      def handle(request)
                
        category_id = request.args[:category_id] 
        hide = (request.args[:hide] || "").to_bool
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        request.log_request
        
        category = BbsBoard[category_id.to_i]
        if (!category)
          return { error: t('webportal.not_found') }
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