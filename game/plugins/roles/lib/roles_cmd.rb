module AresMUSH
  module Roles
    class RolesCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :name
      
      def want_command?(client, cmd)
        cmd.root_is?("roles")
      end

      def crack!
        self.name = cmd.args.nil? ? client.name : trim_input(cmd.args)
      end

      def check_can_assign_role
        return t('dispatcher.not_allowed') if !Roles.can_assign_role?(client.char)
        return nil
      end

      def handle        
        ClassTargetFinder.with_a_character(self.name, client) do |char|
          list = Roles.all_roles.map { |r| "#{char.has_role?(r) ? '(+)' : '(-)'} #{r}"}
          client.emit BorderedDisplay.list(list, t('roles.assigned_roles', :name => char.name))
        end
      end
    end
  end
end
