module AresMUSH
  module FS3Combat
    class TreatCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
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
      
      def handle
        VisibleTargetFinder.with_something_visible(self.name, client) do |model|
          
          if (model.class != Character)
            client.emit_failure t('fs3combat.can_only_treat_characters')
            return
          end
          
          if (model == client.char)
            client.emit_failure t('fs3combat.cant_treat_self')
            return
          end
          
          char = client.char
          ability = char.treat_skill || Global.config["fs3combat"]["default_treat_skill"]
          roll = FS3Skills.one_shot_roll(client, char, :ability => ability)
          
          successes = roll[:successes]
          if (successes > 0)
            Global.logger.info "Treat successful #{char.name} treating #{model.name}: #{roll}"
            if !FS3Combat.heal_wounds(model, successes)
              client.emit_failure t('fs3combat.no_treatable_wounds', :name => model.name)
              return
            end
          end
          
          client.room.emit_ooc t('fs3combat.damage_treated', :doc => char.name, :target => model.name, :success => roll[:success_title]) 
        end
      end
    end
  end
end