module AresMUSH
  module Cron
    mattr_accessor :last_tick
    
    def self.raise_event
      tick = Time.now
      if (!Cron.last_tick || Cron.last_tick.min != tick.min)
        Global.dispatcher.on_event CronEvent.new(tick)
        Cron.last_tick = tick
      end
    end
    
    def self.is_cron_match?(cron_spec, time)
      return false if !cron_spec
      return false if cron_spec.keys.count == 0
      return false if !test_match(cron_spec["date"], time.day, :date)
      return false if !test_match(cron_spec["day_of_week"], time.wday, :day_of_week)
      return false if !test_match(cron_spec["hour"], time.hour, :hour)
      return false if !test_match(cron_spec["minute"], time.min, :min)
      return true
    end
    
    def self.test_match(cron_component, time_component, component_type)
      return true if !cron_component

      case component_type
      when :date, :hour, :min
        cron_component = cron_component.map { |c| c.to_i }
      when :day_of_week
        cron_component = cron_component.map { |c| convert_weekday(c) }
      else
        raise "Invalid cron component: #{component_type}"
      end
      
      return cron_component.include?(time_component)
    end
    
    def self.convert_weekday(weekday)
      return nil if !weekday
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