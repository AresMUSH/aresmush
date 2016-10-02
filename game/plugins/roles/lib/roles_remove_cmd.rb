module AresMUSH
  module Roles
    class RoleRemoveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      attr_accessor :role
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.role = trim_input(cmd.args.arg2)
      end
      
      def required_args
        {
          args: [ self.name, self.role ],
          help: 'roles'
        }
      end
      
      def check_can_assign_role
        return t('dispatcher.not_allowed') if !Roles.can_assign_role?(enactor)
        return t('roles.role_restricted', :name => Game.master.master_admin.name) if (Roles.is_restricted?(self.role) && !enactor.is_master_admin?)
        return nil
      end
      
      def handle        
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |char|

          if (!char.has_role?(self.role))
            client.emit_failure(t('roles.role_not_assigned'))
            return  
          end
        
          char.roles.delete(self.role.downcase)
          char.save!
          client.emit_success t('roles.role_removed', :name => self.name, :role => self.role)
          Global.dispatcher.queue_event RolesChangedEvent.new(char)
        end
      end
    end
  end
end
