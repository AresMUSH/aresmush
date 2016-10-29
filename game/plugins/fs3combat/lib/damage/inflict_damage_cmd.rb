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
        self.severity = cmd.args.arg3 ? cmd.args.arg3.upcase : nil
      end
      
      def required_args
        {
          args: [ self.name, self.desc, self.severity ],
          help: 'combat org'
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
        target = FS3Combat.find_named_thing(self.name, enactor)
            
        if (target)
          FS3Combat.inflict_damage(target, self.severity, self.desc)
          client.emit_success t('fs3combat.damage_inflicted', :name => target.name) 
        else 
          client.emit_failure t('dispatcher.not_found')
        end
      end
    end
  end
end