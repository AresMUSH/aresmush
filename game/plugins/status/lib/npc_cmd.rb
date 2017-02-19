module AresMUSH
  module Status
    class NpcCmd
      include CommandHandler
      
      attr_accessor :option, :name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.option = OnOffOption.new(args.arg2)
      end
      
      def required_args
        {
          args: [ self.option, self.name ],
          help: 'npc'
        }
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle        
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          model.update(is_npc: self.option.is_on?)
          client.emit_ooc self.option.is_on? ? t('status.set_npc_on', :name => model.name) : 
            t('status.set_npc_off', :name => model.name)
        end
      end
    end
  end
end
