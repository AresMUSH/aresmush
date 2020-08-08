module AresMUSH
  module Jobs
    class EditJobCategoryRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args[:id]
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Jobs.can_manage_jobs?(enactor)

        category = JobCategory[id]
        return { error: t('webportal.not_found') } if !category
        
          {
            category: {
              id: category.id,
              name: category.name,
              color: category.color,
              roles: category.roles.map { |r| r.name },
              template: Website.format_input_for_html(category.template)
            },
            roles: Role.all.to_a.sort_by { |r| r.name }.map { |r| r.name }
          }
      end
    end
  end
end


