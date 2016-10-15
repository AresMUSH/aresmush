module AresMUSH
  module FS3Combat
    class TreatCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'damage'
        }
      end
      
      def check_in_combat
        return t('fs3combat.use_combat_treat_instead') if FS3Combat.is_in_combat?(enactor.name)
        return nil
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.name, client, enactor) do |model|
          
          if (model.class != Character)
            client.emit_failure t('fs3combat.can_only_treat_characters')
            return
          end
                    
          enactor_room.emit_ooc FS3Combat.treat(enactor, model)
        end
      end
    end
  end
end