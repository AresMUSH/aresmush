module AresMUSH
  module FS3Combat
    class InflictDamageCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :desc, :severity
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_arg3)
        self.name = titleize_input(cmd.args.arg1)
        self.desc = titleize_input(cmd.args.arg2)
        self.severity = titleize_input(cmd.args.arg3)
      end
      
      def required_args
        {
          args: [ self.name, self.desc, self.severity ],
          help: 'damage'
        }
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !FS3Combat.can_manage_damage?(enactor)
        return nil
      end
      
      def check_severity
        return t('fs3combat.invalid_severity', :severities => FS3Combat.damage_severities.join(" ")) if !FS3Combat.damage_severities.include?(self.severity)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          FS3Combat.inflict_damage(model, self.severity, self.desc)
          client.emit_success t('fs3combat.damage_inflicted', :name => model.name) 
        end
      end
    end
  end
end