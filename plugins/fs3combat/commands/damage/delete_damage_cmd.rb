module AresMUSH
  module FS3Combat
    class DeleteDamageCmd
      include CommandHandler
      
      attr_accessor :name, :num
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
        self.name = titlecase_arg(args.arg1)
        self.num = integer_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.num ]
      end
      
      def handle
        target = FS3Combat.find_named_thing(self.name, enactor)
            
        if (!target)
          client.emit_failure t('db.object_not_found')
          return
        end
        
        if !FS3Combat.can_inflict_damage(enactor, target)
          client.emit_failure t('dispatcher.not_allowed') 
          return nil
        end
      
        damage = target.damage
        if (self.num < 1 || damage.count < self.num)
          client.emit_failure t('fs3combat.invalid_damage_number')
          return
        end
        wound = damage.to_a[self.num - 1]
          
        Global.logger.info "Damage deleted on #{target.name}: old=#{wound.description} #{wound.current_severity}"
          
        wound.delete
          
        client.emit_success t('fs3combat.damage_deleted') 
      end
    end
  end
end