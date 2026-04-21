module AresMUSH
  module Roles
    class RolesCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = !cmd.args ? enactor_name : trim_arg(cmd.args)
      end
      
      def handle        
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |char|
          
          if (char != enactor && !Roles.can_assign_role?(enactor))
            client.emit_failure t('dispatcher.not_allowed') 
            return
          end
          list = Role.all.map { |r| print_role(char, r) }
          template = BorderedListTemplate.new list, 
              t('roles.assigned_roles', :name => char.name),
              t('roles.assigned_roles_footer')
          client.emit template.render
        end
      end
      
      def print_role(char, r)
        has_role = char.has_role?(r) ? '(+)' : '(-)'
        admin_note = r.name == "admin" ? "%xh%xr**%xn" : ""
        permissions = (r.permissions || []).join(', ')
        "#{has_role} #{r.name} - #{permissions} #{admin_note}"
      end
    end
  end
end
