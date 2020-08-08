module AresMUSH
  module Jobs
    class ManageJobCategoriesRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
                
        return { error: t('dispatcher.not_allowed') } if !Jobs.can_manage_jobs?(enactor)
        
        categories = JobCategory.all.to_a.sort_by { |c| c.name }.map { |c|
          {
            id: c.id,
            name: c.name,
            color: c.color,
            roles: c.roles.map { |r| r.name }
          }}
          
          {
            categories: categories,
            roles: Role.all.to_a.sort_by { |r| r.name }.map { |r| r.name }
          }
      end
    end
  end
end


