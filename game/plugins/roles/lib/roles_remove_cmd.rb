module AresMUSH
  module Roles
    class RoleRemoveCmd
      include AresMUSH::Plugin
      
      attr_accessor :name
      attr_accessor :role
      
      # Validators
      must_be_logged_in
      argument_must_be_present "name", "role"
      argument_must_be_present "role", "role"
      must_have_role "admin"

      def want_command?(client, cmd)
        cmd.root_is?("role") && cmd.switch_is?("remove")
      end

      def crack!
        cmd.crack!(/(?<name>[^\=]+)\=(?<role>.+)/)
        self.name = trim_input(cmd.args.name)
        self.role = trim_input(cmd.args.role)
      end
      
      def handle        
        char = Character.find_by_name(self.name)
        
        if (char.nil?)
          client.emit_failure(t("db.no_char_found"))
          return
        end

        if (!char.has_role?(self.role))
          client.emit_failure(t('roles.role_not_assigned'))
          return  
        end
        
        char.roles.delete(self.role.downcase)
        char.save!
        client.emit_success t('roles.role_removed', :name => self.name, :role => self.role)
      end
    end
  end
end
