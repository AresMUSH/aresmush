module AresMUSH
  class OnlineCharFinder
    def self.find(name, client)
      return FindResult.new(client, nil) if (name.downcase == "me")
      online = Global.client_monitor.clients.select { |c| exact_match?(c, name)}
      if (online.count == 0)
        online = Global.client_monitor.clients.select { |c| partial_match?(c, name)}
      end
      
      if (online.count == 0)
        return FindResult.new(nil, t('db.no_char_online_found', :name => name))
      elsif (online.count == 1)
        return FindResult.new(online[0], nil)
      end
      FindResult.new(nil, t('db.ambiguous_char_online', :name => name))
    end
    
    private
    
    def self.exact_match?(client, name)
      name = name.upcase
      char = client.char
      return false if char.nil?
      return true if char.name_upcase == name
      return true if char.alias_upcase == name
      return false
    end
    
    def self.partial_match?(client, name)
      name = name.upcase
      char = client.char
      return false if char.nil?
      return true if char.alias_upcase == name
      return true if char.name_upcase.starts_with?(name)
      return false
    end
  end
end