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
          list = Role.all.map { |r| print_role(char, r) }
          client.emit BorderedDisplay.list(list, t('roles.assigned_roles', :name => char.name))
        end
      end
      
      def print_role(char, r)
        has_role = char.has_role?(r) ? '(+)' : '(-)'
        "#{has_role} #{r.name} - #{r.permissions.join(', ') }"
      end
    end
  end
end
