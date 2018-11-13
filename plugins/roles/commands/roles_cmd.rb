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
          template = BorderedListTemplate.new list, t('roles.assigned_roles', :name => char.name)
          client.emit template.render
        end
      end
      
      def print_role(char, r)
        has_role = char.has_role?(r) ? '(+)' : '(-)'
        "#{has_role} #{r.name} - #{r.permissions.join(', ') }"
      end
    end
  end
end
