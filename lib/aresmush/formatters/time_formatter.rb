module AresMUSH
  class TimeFormatter
    def self.format(seconds)
      if (seconds < 60)
        t('time.seconds', :time => seconds)
      elsif (seconds < 3600)
        t('time.minutes', :time => seconds / 60)
      else
        t('time.hours', :time => seconds / 3600)
      end
    end
  end
end