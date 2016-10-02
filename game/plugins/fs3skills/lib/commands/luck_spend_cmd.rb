module AresMUSH
  module FS3Skills
    class LuckSpendCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
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
      
      def handle
        
        if (enactor.luck < 1)
          client.emit_failure t('fs3skills.not_enough_points')
          return
        end
        
        message = t('fs3skills.luck_point_spent', :name => enactor_name, :reason => reason)
        
        enactor.luck = enactor.luck - 1
        enactor.save
        
        result = Jobs.create_job("REQ", t('fs3skills.luck_job_title'), message, enactor)
        
        enactor_room.emit_ooc message        
          
        Global.logger.info "#{enactor_name} spent luck on #{reason}."
      end
    end
  end
end
