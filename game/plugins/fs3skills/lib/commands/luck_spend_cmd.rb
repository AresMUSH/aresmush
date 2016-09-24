module AresMUSH
  module FS3Skills
    class LuckSpendCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :luck

      def initialize
        self.required_args = ['luck']
        self.help_topic = 'luck'
        super
      end
      
      def crack!
        self.luck = trim_input(cmd.args)
      end
      
      def check_luck
        return nil if self.luck.nil?
        return t('fs3skills.invalid_luck_points') if !self.luck.is_integer?
        return t('fs3skills.invalid_luck_points') if self.luck.to_i <= 0
        return nil
      end
      
      def handle
        count = self.luck.to_i
        
        if (count > client.char.luck)
          client.emit_failure t('fs3skills.not_enough_points')
          return
        end
        
        message = t('fs3skills.luck_point_spent', :name => client.name, :count => count)
        
        client.char.luck = client.char.luck - count
        client.char.save
        
        client.room.emit_ooc message
        Global.client_monitor.logged_in_clients.each do |c|
          next if c == client
          next if c.room == client.room
          if (FS3Skills.can_manage_luck?(c.char))
            c.emit_ooc message
          end
        end
        Global.logger.info "#{client.name} spent #{count} luck points."
      end
    end
  end
end
