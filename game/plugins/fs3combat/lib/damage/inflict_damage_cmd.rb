module AresMUSH
  module FS3Combat
    class InflictDamageCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :desc, :severity
      
      def initialize
        self.required_args = ['name', 'desc', 'severity']
        self.help_topic = 'damage'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("damage") && cmd.switch_is?("inflict")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_arg3)
        self.name = titleize_input(cmd.args.arg1)
        self.desc = titleize_input(cmd.args.arg2)
        self.severity = titleize_input(cmd.args.arg3)
      end
      
      def check_severity
        return t('fs3combat.invalid_severity') if !FS3Combat.damage_severities.include?(self.severity)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          FS3Combat.inflict_damage(model, self.severity, self.desc, false)
          model.save
          client.emit_success t('fs3combat.damage_inflicted', :name => model.name) 
        end
      end
    end
  end
end