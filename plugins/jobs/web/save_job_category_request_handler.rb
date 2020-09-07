module AresMUSH
  module Jobs
    class SaveJobCategoryRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        name = (request.args[:name] || "").upcase
        color = request.args[:color]
        roles = request.args[:roles] || []
        template = request.args[:template] || ""
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Jobs.can_manage_jobs?(enactor)

        category = JobCategory[id]
        return { error: t('webportal.not_found') } if !category

        if (name.blank?)
          return { error: t('jobs.category_name_required')}      
        end
                
        other_cat = JobCategory.named(name)
        if (other_cat && other_cat != category)
          return { error: t('jobs.category_already_exists') }
        end

        category.update(name: name, color: color, template: Website.format_input_for_mush(template))
        category.set_roles(roles)
        
        
        {}
      end
    end
  end
end


