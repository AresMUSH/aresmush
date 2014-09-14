module AresMUSH
  module Cron
    mattr_accessor :last_tick
    
    def self.raise_event
      tick = Time.now
      if (Cron.last_tick.nil? || Cron.last_tick.min != tick.min)
        Global.dispatcher.on_event CronEvent.new(tick)
        Cron.last_tick = tick
      end
    end
    
    def self.is_cron_match?(cron_spec, time)
      return false if !test_match(cron_spec["date"], time.day)
      return false if !test_match(convert_weekday(cron_spec["day_of_week"]), time.wday)
      return false if !test_match(cron_spec["hour"], time.hour)
      return false if !test_match(cron_spec["minute"], time.min)
      return true
    end
    
    def self.test_match(cron_component, time_component)
      return true if cron_component.nil?
      return cron_component == time_component
    end
    
    def self.convert_weekday(weekday)
      return nil if weekday.nil?
      case weekday.upcase
      when "SUN"
        0
      when "MON"
        1
      when "TUE"
        2
      when "WED"
        3
      when "THU"
        4
      when "FRI"
        5
      when "SAT"
        6
      end
    end
  end
end