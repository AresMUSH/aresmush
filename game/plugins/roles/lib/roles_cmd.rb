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
        ClassTargetFinder.with_a_character(self.name, client) do |char|
          list = Roles.all_roles.map { |r| "#{char.has_role?(r) ? '(+)' : '(-)'} #{r}"}
          client.emit BorderedDisplay.list(list, t('roles.assigned_roles', :name => char.name))
        end
      end
    end
  end
end
