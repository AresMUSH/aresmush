module AresMUSH
  module OOCTime
    
    def self.local_short_timestr(viewer, datetime)
      return "" if !datetime
      lt = localtime(viewer, datetime)
      l(lt, format: Global.read_config("datetime", "short_date_format"))
    end

    def self.local_long_timestr(viewer, datetime)
      return "" if !datetime
      lt = localtime(viewer, datetime)
      l(lt, format: Global.read_config("datetime", "long_date_format"))
    end
    
    def self.local_short_date_and_time(viewer, datetime)
      return "" if !datetime
      lt = localtime(viewer, datetime)
      date = l(lt, format: Global.read_config("datetime", "short_date_format"))
      time = l(lt, format: Global.read_config("datetime", "time_format"))
      "#{date} #{time}"
    end
    
    
    def self.localtime(viewer, datetime)
      return "" if !datetime
      setting = viewer ? viewer.timezone : nil
      timezone = Timezone[setting || "America/New_York"]
      timezone.time datetime      
    end
    
    def self.parse_datetime(datetime)
      Time.strptime(datetime, OOCTime.date_and_time_entry_format)
    end
    
    def self.format_date_time_for_entry(datetime)
      datetime.strftime OOCTime.date_and_time_entry_format
    end

    def self.format_date_for_entry(datetime)
      datetime.strftime Global.read_config("datetime", "short_date_format")
    end
    
    def self.date_and_time_entry_format
      date_format = Global.read_config("datetime", "short_date_format")
      time_format = Global.read_config("datetime", "time_format")
      "#{date_format} #{time_format}"
    end
    
    def self.date_element_separator
      date_format = Global.read_config("datetime", "short_date_format")
      if (date_format =~ /-/)
        return '-'
      else
        return '/'
      end
    end
    
    def self.server_timestr(time = Time.now)
      timezone = Global.read_config("datetime", "server_timezone")
      format = Global.read_config("datetime", "time_format")
      formatted_time = l(time, format: format)
      
      "#{formatted_time.strip} #{timezone}"
    end
    
    def self.timezone_names
      Timezone.names
    end
    
    def self.set_timezone(char, zone)
      zone = OOCTime.convert_timezone_alias(zone)
      if (!OOCTime.timezone_names.include?(zone))
        return t('time.invalid_timezone')
      end
      
      char.update(ooctime_timezone: zone)
      return nil
    end
  end
end