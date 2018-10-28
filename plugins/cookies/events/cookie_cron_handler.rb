module AresMUSH
  module Cookies    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("cookies", "cookie_award_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Issuing cookies."
        
        cookies_per_luck = Global.read_config("cookies", "cookies_per_luck")
        
        awards = ""
        counts = {}
        CookieAward.all.each do |c|
          recipient = c.recipient
          if (counts.has_key?(c.recipient))
            counts[recipient] = counts[recipient] + 1
          else
            counts[recipient] = 1 
          end
          c.delete
        end
        
        counts.sort_by { |char, count| count }.reverse.each_with_index do |(char, count), i|
          index = i+1
          if (i <= 10)
            num = "#{index.to_s}."
            awards << "#{num.ljust(3)} #{char.name.ljust(20)}#{count}\n"
          end
          
          if (cookies_per_luck != 0)
            luck = count.to_f / cookies_per_luck
            char.award_luck(luck)
          end
          
          char.update(total_cookies: char.total_cookies + count)
          
          [1, 10, 25, 50, 100, 200, 500, 1000].each do |count|
            if (char.total_cookies >= count)
              Achievements.award_achievement(char, "cookie_received_#{count}", 'community', "Received #{count} cookies.")
            end
          end

        end
        
        return if awards.blank?
        
        Forum.system_post(
          Global.read_config("cookies", "cookie_category"),
          t('cookies.weekly_award_title'), 
          awards.chomp)
      end
    end    
  end
end