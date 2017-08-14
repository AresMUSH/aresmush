module AresMUSH
  module Demographics
    class GroupDetailCmd
      include CommandHandler
      
      attr_accessor :name

      def help
        "`groups` - List all group types.\n" +
        "`group <type>` - Shows options available for a group type."
      end

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def required_args
        [ self.name ]
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
