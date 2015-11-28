module AresMUSH
  module FS3Combat
    class TreatCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'damage'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("treat") && cmd.switch.nil?
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_in_combat
        return t('fs3combat.use_combat_treat_instead') if FS3Combat.is_in_combat?(client.char.name)
        return nil
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.name, client) do |model|
          
          if (model.class != Character)
            client.emit_failure t('fs3combat.can_only_treat_characters')
            return
          end
                    
          client.room.emit_ooc FS3Combat.do_treat(client.char, model)
        end
      end
    end
  end
end