module AresMUSH
  module Roles
    class RolesCmd
      include AresMUSH::Plugin
      
      attr_accessor :name
      
      # Validators
      must_be_logged_in

      def want_command?(client, cmd)
        cmd.root_is?("roles")
      end

      def crack!
        self.name = cmd.args.nil? ? client.name : trim_input(cmd.args)
      end

      def handle        
        char = Character.find_by_name(self.name)
        
        if (char.nil?)
          client.emit_failure(t("db.no_char_found"))
          return
        end
        
        list = Roles.all_roles.map { |r| "#{char.has_role?(r) ? '(+)' : '(-)'} #{r}"}
        client.emit BorderedDisplay.list(list, t('roles.assigned_roles', :name => char.name))
      end
    end
  end
end
