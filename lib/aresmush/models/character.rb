module AresMUSH
  class Character
    include ObjectModel

    belongs_to :room, :class_name => 'AresMUSH::Room', :inverse_of => nil
    
    register_default_indexes with_unique_name: true

    def api_character_id
      data = "#{Game.master.api_game_id}#{id}"
      Base64.strict_encode64(data).encode('ASCII-8BIT')
    end
    
    def serializable_hash(options={})
      hash = super(options)
      hash[:room] = self.room_id
      hash
    end 
    
    def self.random_link_code
      (0...8).map { (65 + rand(26)).chr }.join
    end 
  end
end
    