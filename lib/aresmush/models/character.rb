module AresMUSH
  class Character
    include ObjectModel

    field :handle, :type => String
    field :handle_id, :type => String

    belongs_to :room, :class_name => 'AresMUSH::Room', :inverse_of => nil
    
    register_default_indexes with_unique_name: true
    
    def self.find_by_handle(name)
      return [] if name.nil?
      Character.all.select { |c| (c.handle.nil? ? "" : c.handle.downcase) == name.downcase }
    end
    
    
    def name_and_alias
      if (self.alias.blank?)
        name
      else
        "#{name} (#{self.alias})"
      end
    end

    def api_character_id
      data = "#{Game.master.api_game_id}#{id}"
      Base64.strict_encode64(data).encode('ASCII-8BIT')
    end
    
    def serializable_hash(options={})
      hash = super(options)
      hash[:room] = self.room_id
      hash[:id] = self.id.to_s
      hash
    end 
    
    def client
      Global.client_monitor.find_client(self)
    end
    
    def is_online?
      !self.client.nil?
    end
    
    def self.random_link_code
      (0...8).map { (65 + rand(26)).chr }.join
    end 
  end
end
    