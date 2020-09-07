module AresMUSH
  module Jobs
    class CreateJobCategoryRequestHandler
      def handle(request)
        enactor = request.enactor
        name = (request.args[:name] || "").upcase
        color = request.args[:color]
        roles = request.args[:roles] || []
        template = request.args[:template] || ""
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Jobs.can_manage_jobs?(enactor)

        if (name.blank?)
          return { error: t('jobs.category_name_required')}      
        end
        
        other_cat = JobCategory.named(name)
        if (other_cat)
          return { error: t('jobs.category_already_exists') }
        end

        Global.logger.info "Job Category #{name} created by #{enactor.name}."
        
        category = JobCategory.create(name: name, color: color, template: template)
        category.set_roles(roles)

        {}
      end
    end
  end
end


