module AresMUSH
  module Cookies    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("cookies", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        cookies_per_luck = Global.read_config("cookies", "cookies_per_luck")
        
        awards = ""
        cookie_recipients = Character.all.select { |c| c.cookies_received.any? }
        cookie_recipients = cookie_recipients.sort_by { |c| c.cookies_received.count }.reverse
        cookie_recipients.each_with_index do |c, i|
          count = c.cookies_received.count
          index = i+1
          awards << "#{index}. #{c.name.ljust(20)}#{count}\n"
          c.cookie_count = c.cookie_count + count
          
          if (cookies_per_luck != 0)
            luck = count.to_f / cookies_per_luck
            FS3Luck::Api.add_luck(client.char)
          end

          Global.logger.info "#{c.name} got #{count} cookies from #{c.cookies_received.map{|a| a.name}.join(",")}"

          c.cookies_received = []          
          c.save
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