module AresMUSH
  class OnlineCharResult
    attr_accessor :client, :char
    def initialize(client, char)
      @client = client
      @char = char
    end
  end
  
  class OnlineCharFinder
    def self.find(name, client, allow_handles = false)
      return FindResult.new(client, nil) if (name.downcase == "me")
      online = Global.client_monitor.logged_in
          .select { |other_client, other_char| exact_match?(other_char, name, allow_handles, client)}
          .map { |other_client, other_char| OnlineCharResult.new(other_client, other_char )}
      if (online.count == 0)
        online = Global.client_monitor.logged_in
        .select { |other_client, other_char| partial_match?(other_char, name, allow_handles, client)}
        .map { |other_client, other_char| OnlineCharResult.new(other_client, other_char )}
      end
      
      if (online.count == 0)
        return FindResult.new(nil, t('db.no_char_online_found', :name => name))
      elsif (online.count == 1)
        return FindResult.new(online.first, nil)
      end
      FindResult.new(nil, t('db.ambiguous_char_online', :name => name))
    end
    
    def self.with_online_chars(names, client, allow_handles = false, &block)
      to_clients = []
      names.each do |name|
        result = self.find(name, client, allow_handles)
                
        if (!result.found?)
          client.emit_failure(result.error)
          return
        end
        to_clients << result.target
      end
      yield to_clients
    end
    
    private
    
    def self.exact_match?(char, name, allow_handles, viewer)
      name = name.upcase
      return false if name.blank?
      return false if !char
      return true if char.name_upcase == name
      return true if char.alias_upcase == name
      return true if allow_handles && char.handle && char.handle.upcase == name && char.handle_visible_to?(viewer)
      return false
    end
    
    def self.partial_match?(char, name, allow_handles, viewer)
      name = name.upcase
      return false if name.blank?
      return false if !char
      return true if char.name_upcase.start_with?(name)
      return true if allow_handles && char.handle && char.handle.upcase.start_with?(name) && char.handle_visible_to?(viewer)
      return false
    end
  end
end