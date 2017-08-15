module AresMUSH
  module FS3Combat
    class HealStopCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          healing = Healing.find(character_id: enactor.id).combine(patient_id: model.id).first
                           
          if (!healing)
            client.emit_failure t('fs3combat.not_healing', :name => self.name)
            return
          end
          
          healing.delete
          client.emit_success t('fs3combat.stop_heal', :name => self.name)
        end
      end
    end
  end
end