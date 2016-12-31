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
          list = Roles.all_roles.map { |r| "#{char.has_role?(r) ? '(+)' : '(-)'} #{r}"}
          client.emit BorderedDisplay.list(list, t('roles.assigned_roles', :name => char.name))
        end
      end
    end
  end
end
