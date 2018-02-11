module AresMUSH
  module FS3Combat
    class HealStartCmd
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
          patients = enactor.patients
          
          if (patients.include?(model))
            client.emit_failure t('fs3combat.already_healing', :name => self.name)
            return
          end

          if (patients.count >= FS3Combat.max_patients(enactor))
            client.emit_failure t('fs3combat.no_more_patients')
            return
          end
          
          Healing.create(character: enactor, patient: model)
          client.emit_success t('fs3combat.start_heal', :name => self.name)
        end
      end
    end
  end
end