module AresMUSH
  module OOCTime
    def self.localtime(client, datetime)
      timezone = Timezone::Zone.new :zone => client.char.nil? ? "America/New_York" : client.char.timezone
      timezone.time datetime
    end
    
    def self.local_month_str(client, datetime)
      lt = localtime(client, datetime)
      lt.strftime("%Y-%m-%d")
    end

    def self.local_time_str(client, datetime)
      lt = localtime(client, datetime)
      lt.strftime("%a %b %d, %Y %l:%M%P")
    end
    
  end
end