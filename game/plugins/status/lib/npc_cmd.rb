module AresMUSH
  module Status
    class NpcCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs
      
      attr_accessor :option, :name
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.option = OnOffOption.new(cmd.args.arg2)
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
