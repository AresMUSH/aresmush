module AresMUSH
  module Jobs
    class DeleteJobCategoryRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Jobs.can_manage_jobs?(enactor)

        category = JobCategory[id]
        return { error: t('webportal.not_found') } if !category
        
        if (JobCategory.all.count == 1)
          return { error: t('jobs.cant_delete_only_category') }
        end
        
        if (category.jobs.count > 0)
          return { error: t('jobs.only_delete_empty_categories') }
        end
        
        Global.logger.info "Job Category #{category.name} deleted by #{enactor.name}."
        category.delete
                  
        {}
      end
    end
  end
end


