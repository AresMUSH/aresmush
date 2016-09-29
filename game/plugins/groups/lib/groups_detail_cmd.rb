module AresMUSH
  module Groups
    class GroupDetailCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name

      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'groups'
        super
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        group = Groups.get_group(self.name)
        
        if (group.nil?)
          client.emit_failure t('groups.invalid_group_type')
          return
        end
        
        template = GroupDetailTemplate.new(self.name, group)
        client.emit template.render        
      end
    end
  end
end
