module AresMUSH
  module Cookies    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("cookies", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
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
        
        counts.each_with_index do |(char, count), i|
          index = i+1
          awards << "#{index}. #{char.name.ljust(20)}#{count}\n"
          
          if (cookies_per_luck != 0)
            luck = count.to_f / cookies_per_luck
            c.award_luck(luck)
          end

        end
        
        return if awards.blank?
        
        Bbs::Api.system_post(
          Global.read_config("cookies", "cookie_board"),
          t('cookies.weekly_award_title'), 
          awards.chomp)
      end
    end    
  end
end