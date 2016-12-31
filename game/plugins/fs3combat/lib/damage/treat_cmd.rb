module AresMUSH
  module FS3Combat
    class TreatCmd
      include CommandHandler
      
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
            client.emit_failure t('db.object_not_found')
            return
          end
                    
          enactor_room.emit_ooc FS3Combat.treat(model, enactor)
        end
      end
    end
  end
end