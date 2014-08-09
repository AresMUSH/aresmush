module AresMUSH
  module Cookies    
    class CookieCronHandler
      include Plugin
      
      def on_cron_event(event)
        config = Global.config['cookies']['cron']
        return if !Cron.is_cron_match?(config, event.time)
        
        awards = ""
        cookie_recipients = Character.all.select { |c| c.cookies_received.any? }
        cookie_recipients = cookie_recipients.sort_by { |c| c.cookies_received.count }.reverse
        cookie_recipients.each_with_index do |c, i|
          count = c.cookies_received.count
          index = i+1
          awards << "#{index}. #{c.name.ljust(20)}#{count}\n"
          c.cookie_count = c.cookie_count + count
          c.cookies_received = []
          c.save
        end
        
        cookie_board = Global.config['cookies']['cookie_board']
        if (!cookie_board.nil? && !cookie_board.empty?)
          Bbs.post(cookie_board, t('cookies.weekly_award_title'), awards.chomp, Game.master.system_character)
        end
      end
    end    
  end
end