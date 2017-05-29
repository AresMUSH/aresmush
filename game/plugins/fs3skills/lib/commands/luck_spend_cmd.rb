module AresMUSH
  module FS3Skills
    class LuckSpendCmd
      include CommandHandler
      
      attr_accessor :reason

      def parse_args
        self.reason = trim_arg(cmd.args)
      end

      def required_args
        {
          args: [ self.reason ],
          help: 'luck'
        }
      end
      
      def checK_luck
        return t('fs3skills.not_enough_points') if enactor.luck < 1
        return nil
      end
      
      def handle
        
        enactor.spend_luck(1)
        enactor_room.emit_ooc t('fs3skills.luck_point_spent', :name => enactor_name, :reason => reason)
          
        Global.logger.info "#{enactor_name} spent luck on #{reason}."
      end
    end
  end
end
