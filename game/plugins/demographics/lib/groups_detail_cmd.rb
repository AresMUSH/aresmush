module AresMUSH
  module Demographics
    class GroupDetailCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def required_args
        {
          args: [ self.name ],
          help: 'groups'
        }
      end
      
      def handle
        group = Demographics.get_group(self.name)
        
        if (!group)
          client.emit_failure t('demographics.invalid_group_type')
          return
        end
        
        template = GroupDetailTemplate.new(self.name, group)
        client.emit template.render        
      end
    end
  end
end
