module AresMUSH
  module FS3Combat
    class InflictDamageCmd
      include CommandHandler
      
      attr_accessor :name, :desc, :severity
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.name = titlecase_arg(args.arg1)
        self.desc = titlecase_arg(args.arg2)
        self.severity = upcase_arg(args.arg3)
      end
      
      def required_args
        [ self.name, self.desc, self.severity ]
      end
      
      def check_severity
        return t('fs3combat.invalid_severity', :severities => FS3Combat.damage_severities.join(" ")) if !FS3Combat.damage_severities.include?(self.severity)
        return nil
      end
      
      def handle
        target = FS3Combat.find_named_thing(self.name, enactor)

        if (!target)
          client.emit_failure t('db.object_not_found')
          return
        end
            
        if !FS3Combat.can_inflict_damage(enactor, target)
          client.emit_failure t('dispatcher.not_allowed') 
          return
        end
            
        FS3Combat.inflict_damage(target, self.severity, self.desc)
        client.emit_success t('fs3combat.damage_inflicted', :name => target.name) 
      
      end
    end
  end
end