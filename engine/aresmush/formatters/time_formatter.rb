module AresMUSH
  class TimeFormatter
    def self.format(seconds)
      seconds = seconds.floor
      if (seconds < 60)
        t('time.seconds', :time => seconds)
      elsif (seconds < 3600)
        t('time.minutes', :time => seconds / 60)
      elsif (seconds < 86400)
        t('time.hours', :time => seconds / 3600)
      else
        t('time.days', :time => seconds / 86400)
      end
    end
  end
end