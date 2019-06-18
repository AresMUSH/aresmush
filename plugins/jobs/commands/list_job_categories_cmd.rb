module AresMUSH
  module Jobs
    class ListJobCaegoriesCmd
      include CommandHandler
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
         template = JobCategoriesListTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end
