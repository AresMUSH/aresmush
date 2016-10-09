module AresMUSH

  module FS3Skills
    class XpInterestCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name

      def crack!
        self.name = titleize_input(cmd.args)
      end

      def required_args
        {
          args: [ self.name ],
          help: 'xp'
        }
      end
      
      def check_approval
        return t('fs3skills.not_approved') if !enactor.is_approved?
        return nil
      end
      
      def handle
        cost = Global.read_config("fs3skills", "interest_cost")
        
        if (enactor.xp < cost)
          client.emit_failure t('fs3skills.not_enough_xp', :cost => cost)
          return
        end
        
        if (FS3Skills.add_unrated_ability(client, enactor, self.name, :interest))
          Global.logger.info "XP Spend: #{enactor_name} got interest #{self.name}."
          enactor.xp = enactor.xp - cost
          enactor.last_xp_spend = Time.now
          enactor.save
        end
      end
    end
  end
end
