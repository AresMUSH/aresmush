module AresMUSH
  module FS3Skills
    class LuckSpendCmd
      include CommandHandler
      
      attr_accessor :reason

      def crack!
        self.reason = trim_input(cmd.args)
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
        
        message = t('fs3skills.luck_point_spent', :name => enactor_name, :reason => reason)
        
        enactor.spend_luck(1)
        result = Jobs.create_job("REQ", t('fs3skills.luck_job_title'), message, Game.master.system_character)
        
        enactor_room.emit_ooc message        
          
        Global.logger.info "#{enactor_name} spent luck on #{reason}."
      end
    end
  end
end
