module AresMUSH
  module FS3Skills
    class LuckSpendCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :luck

      def initialize(client, cmd, enactor)
        self.required_args = ['luck']
        self.help_topic = 'luck'
        super
      end
      
      def crack!
        self.luck = trim_input(cmd.args)
      end
      
      def check_luck
        return nil if !self.luck
        return t('fs3skills.invalid_luck_points') if !self.luck.is_integer?
        return t('fs3skills.invalid_luck_points') if self.luck.to_i <= 0
        return nil
      end
      
      def handle
        count = self.luck.to_i
        
        if (count > enactor.luck)
          client.emit_failure t('fs3skills.not_enough_points')
          return
        end
        
        message = t('fs3skills.luck_point_spent', :name => enactor_name, :count => count)
        
        enactor.luck = enactor.luck - count
        enactor.save
        
        enactor_room.emit_ooc message        
          
        Global.logger.info "#{enactor_name} spent #{count} luck points."
      end
    end
  end
end
