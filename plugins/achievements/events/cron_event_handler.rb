module AresMUSH
  module Achievements  
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("achievements", "notification_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Posting achievements."

        forum = Global.read_config("achievements", "notification_category") || ""
        days = Global.read_config("achievements", "notification_days") || 1
        
        if (!forum.empty?)
          achievements = Achievement.all.select { |a| Time.now - a.updated_at < 86400 * days }.sort_by { |a| a.updated_at }
          message = t('achievements.achievements_earned_message', :days => days)
          message << "%R"
          achievements.each do |a|
            message << "%R#{a.character.name.ljust(20)} #{a.message}"
          end
          Forum.post(forum, t('achievements.achievements_earned_title'), message, Game.master.system_character)
        end
             
      end
    end
  end
end