module AresMUSH
  module Forum
    class ForumCatchupRequestHandler
      def handle(request)
                
        category_id = request.args[:category_id] 
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        request.log_request

        if (category_id)
          category = BbsBoard[category_id.to_i]
          if (!category)
            return { error: t('webportal.not_found') }
          end
          categories = [ category ]
        else
          categories = BbsBoard.all.to_a
        end
        
        categories.each do |category|
          if (Forum.can_read_category?(enactor, category))           
            Forum.catchup_category(enactor, category)
          end
        end
        
        {}
      end
    end
  end
end