module AresMUSH

  module FS3XP
    class XpRaiseCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'xp'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("xp") && cmd.switch_is?("raise")
      end

      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_approval
        return t('fs3xp.not_approved') if !client.char.is_approved
        return nil
      end
      
      def handle
        current_rating = FS3Skills.ability_rating(client.char, self.name)
        max_rating = Global.read_config("fs3xp", "max_rating_through_xp")
        if (current_rating >= max_rating)
          client.emit_failure t('fs3xp.cant_raise_further_with_xp')
          return
        end
        
        error = FS3XP.check_raise_frequency(client.char)
        if (!error.nil?)
          client.emit_failure error
          return
        end
        
        cost = FS3XP.cost_for_rating(current_rating + 1)
        
        if (client.char.xp < cost)
          client.emit_failure t('fs3xp.not_enough_xp', :cost => cost)
          return
        end
        
        if (FS3Skills.set_ability(client, client.char, self.name, current_rating + 1))
          Global.logger.info "XP Spend: #{client.name} raised #{self.name} to #{current_rating + 1}."
          client.char.xp = client.char.xp - cost
          client.char.last_xp_spend = Time.now
          client.char.save
        end
      end
    end
  end
end
