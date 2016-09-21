module AresMUSH

  module FS3XP
    class XpInterestCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'xp'
        super
      end

      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_approval
        return t('fs3xp.not_approved') if !client.char.is_approved
        return nil
      end
      
      def handle
        cost = Global.read_config("fs3xp", "interest_cost")
        
        if (client.char.xp < cost)
          client.emit_failure t('fs3xp.not_enough_xp', :cost => cost)
          return
        end
        
        if (FS3Skills.add_unrated_ability(client, client.char, self.name, :interest))
          Global.logger.info "XP Spend: #{client.name} got interest #{self.name}."
          client.char.xp = client.char.xp - cost
          client.char.last_xp_spend = Time.now
          client.char.save
        end
      end
    end
  end
end
