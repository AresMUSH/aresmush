module AresMUSH
  module FS3Skills
    class LuckFatigueCmd
      include CommandHandler
      
      def check_luck
        return t('fs3skills.not_enough_points') if enactor.luck < 1
        return nil
      end
      
      def handle
        current_fatigue = enactor.fatigue
        new_fatigue = current_fatigue.to_i - 1

        if (new_fatigue < 0)
          client.emit_failure("Your fatigue is already at 0.")
          return nil
        end

        secs = Time.now.to_i
        last_lp_secs = enactor.fatigue_last_lp
        last_time = Time.at(last_lp_secs.to_i)
        elapsed = secs - last_lp_secs.to_i
        hours_to_go = (86400 - elapsed) / 3600

        if (hours_to_go < 1)
          to_go = (86400 - elapsed) / 60
          remaining = "min"
        else
          to_go = hours_to_go
          remaining = "hr"
        end

        if (elapsed < 86400)
          client.emit_failure("You can only lower fatigue once per day.  Can be used again in: #{to_go}#{remaining}.")
          return nil
        end

        message = "You spend a luck point to lower your fatigue by one.  Now at: #{new_fatigue} / 7."
        enactor.spend_luck(2)
        enactor.update(fatigue: new_fatigue)
        client.emit_ooc message
       
        Achievements.award_achievement(enactor, "fs3_luck_spent")
          
        Global.logger.info "#{enactor_name} spent 1 luck to lower fatigue by 1."
      end
    end
  end
end
