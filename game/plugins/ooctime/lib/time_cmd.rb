module AresMUSH
  module OOCTime
    class TimeCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandWithoutArgs
           
      def handle
        server_time = t('time.server_time', :time => DateTime.now.strftime("%a %b %d, %Y %l:%M%P"))
        local_time = t('time.local_time', :time => OOCTime.local_long_timestr(client, Time.now))
        timezone = t('time.timezone', :timezone => client.char.timezone)
        display_text = "#{server_time}%r#{local_time}%r%r#{timezone}"
        client.emit BorderedDisplay.text display_text
      end
    end
  end
end
