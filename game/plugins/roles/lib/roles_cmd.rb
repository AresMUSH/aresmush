module AresMUSH
  module Roles
    class RolesCmd
      include AresMUSH::Plugin
      
      attr_accessor :name
      
      # Validators
      must_be_logged_in
      argument_must_be_present "name", "roles"

      def want_command?(client, cmd)
        cmd.root_is?("roles")
      end

      def crack!
        self.name = trim_input(cmd.args)
      end

      def validate_name
        if self.email !~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
          return t('login.invalid_email_format')
        end
        return nil
      end
      
      def handle        
        char = Character.find_by_name(self.name)
        
        if (char.nil?)
          client.emit_failure(t("db.no_char_found"))
          return
        end
        
        client.emit_ooc t('roles.assigned_roles', :roles => char.roles)
      end
    end
  end
end
