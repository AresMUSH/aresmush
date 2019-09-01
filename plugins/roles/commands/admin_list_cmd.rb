module AresMUSH
  module Roles
    class AdminListCmd
      include CommandHandler
            
      def handle
        admins_by_role = Roles.admins_by_role
        template = AdminTemplate.new(admins_by_role)
        client.emit template.render
      end
    end
  end
end
