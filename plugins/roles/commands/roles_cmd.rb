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
          
          template = RolesForCharTemplate.new char
          client.emit template.render
        end
      end
    end
  end
end
