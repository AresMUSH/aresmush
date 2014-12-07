module AresMUSH
  module OOCTime
    def self.localtime(client, datetime)
      return "" if datetime.nil?
      timezone = Timezone::Zone.new :zone => client.char.nil? ? "America/New_York" : client.char.timezone
      timezone.time datetime
    end
    
    def self.local_short_timestr(client, datetime)
      return "" if datetime.nil?
      lt = localtime(client, datetime)
      lt.strftime Global.config["date_and_time"]["short_date_format"]
    end

    def self.local_long_timestr(client, datetime)
      return "" if datetime.nil?
      lt = localtime(client, datetime)
      lt.strftime Global.config["date_and_time"]["long_date_format"]
    end
    
  end
end