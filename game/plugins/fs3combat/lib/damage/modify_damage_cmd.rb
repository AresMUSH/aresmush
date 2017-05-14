module AresMUSH
  module FS3Combat
    class ModifyDamageCmd
      include CommandHandler
      
      attr_accessor :name, :num, :desc, :severity
      
      def parse_args
        # char/damage#=desc/severity
        args = cmd.parse_args(/(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=(?<arg3>[^\/]+)\/(?<arg4>.+)/)
        self.name = titlecase_arg(args.arg1)
        self.num = integer_arg(args.arg2)
        self.desc = titlecase_arg(args.arg3)
        self.severity = upcase_arg(args.arg4)
      end
      
      def required_args
        {
          args: [ self.name, self.num, self.desc, self.severity ],
          help: 'damage'
        }
      end
      
      def check_severity
        return t('fs3combat.invalid_severity', :severities => FS3Combat.damage_severities.join(" ")) if !FS3Combat.damage_severities.include?(self.severity)
        return nil
      end
      
      def handle
        target = FS3Combat.find_named_thing(self.name, enactor)
            
        if !FS3Combat.can_inflict_damage(enactor, target)
          client.emit_failure t('dispatcher.not_allowed') 
          return nil
        end
      
        if (target)
          
          damage = target.damage
          if (self.num < 1 || damage.count < self.num)
            client.emit_failure t('fs3combat.invalid_damage_number')
            return
          end
                    
          wound = damage.to_a[self.num - 1]
          
          Global.logger.info "Damage modified on #{target.name}: old=#{wound.description} #{wound.current_severity} new=#{self.desc} #{self.severity}"
          
          wound.update(current_severity: self.severity)
          wound.update(initial_severity: self.severity)
          wound.update(description: self.desc)
          wound.update(healing_points: FS3Combat.healing_points(self.severity))
          
          client.emit_success t('fs3combat.damage_modified') 
        else 
          client.emit_failure t('db.object_not_found')
        end
      end
      

      
    end
  end
end