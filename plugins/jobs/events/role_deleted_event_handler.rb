module AresMUSH
  module Jobs
    class RoleDeletedEventHandler
      def on_event(event)
        JobCategory.all.each do |category|
          category.roles.each do |r|
            if (r.id == event.role_id)
              Global.logger.debug "Deleting role from job category #{category.name}."
              category.roles.delete r
            end
          end
        end
      end
    end
  end
end