module AresMUSH
  class OnlineCharFinder
    def self.find(name, client)
      return FindResult.new(client, nil) if (name.downcase == "me")
      online = Global.client_monitor.clients.select { |c| !c.name.nil? && c.name.upcase.starts_with?(name.upcase) }
      
      if (online.count == 0)
        return FindResult.new(nil, t('db.no_char_online_found', :name => name))
      elsif (online.count == 1)
        return FindResult.new(online[0], nil)
      end
      FindResult.new(nil, t('db.ambiguous_char_online', :name => name))
    end
  end
end