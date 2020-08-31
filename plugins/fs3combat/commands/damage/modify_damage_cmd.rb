module AresMUSH
  module FS3Combat
    class ModifyDamageCmd
      include CommandHandler
      
      attr_accessor :name, :num, :desc, :current_severity, :initial_severity, :ictime_str
      
      def parse_args
        # char/damage#=desc/init severity/curr severity/ictime
        args = cmd.parse_args(/(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=(?<arg3>[^\/]+)\/(?<arg4>[^\/]+)\/(?<arg5>[^\/]+)\/(?<arg6>.+)/)
        self.name = titlecase_arg(args.arg1)
        self.num = integer_arg(args.arg2)
        self.desc = titlecase_arg(args.arg3)
        self.initial_severity = upcase_arg(args.arg4)
        self.current_severity = upcase_arg(args.arg5)
        self.ictime_str = args.arg6
      end
      
      def required_args
        [ self.name, self.num, self.desc, self.initial_severity, self.current_severity, self.ictime_str]
      end
      
      def check_severity
        return t('fs3combat.invalid_severity', :severities => FS3Combat.damage_severities.join(" ")) if !FS3Combat.damage_severities.include?(self.current_severity)
        return t('fs3combat.invalid_severity', :severities => FS3Combat.damage_severities.join(" ")) if !FS3Combat.damage_severities.include?(self.initial_severity)
        return nil
      end
      
      def check_date
        begin
          day = Date.strptime(self.ictime_str, Global.read_config("datetime", "short_date_format"))
          return nil
        rescue
          return t('fs3combat.invalid_damage_date', 
          :format_str => Global.read_config("datetime", "date_entry_format_help"))
        end
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
          
          Global.logger.info "Damage modified on #{target.name}: old=#{wound.description} #{wound.current_severity} new=#{self.desc} #{self.initial_severity} #{self.current_severity}"
          
          wound.update(current_severity: self.current_severity)
          wound.update(initial_severity: self.initial_severity)
          wound.update(description: self.desc)
          wound.update(healing_points: FS3Combat.healing_points(self.current_severity))
          wound.update(ictime_str: self.ictime_str)
          client.emit_success t('fs3combat.damage_modified') 
        else 
          client.emit_failure t('db.object_not_found')
        end
      end
      

      
    end
  end
end