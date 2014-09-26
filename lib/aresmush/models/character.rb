module AresMUSH
  class Character
    include ObjectModel

    belongs_to :room, :class_name => 'AresMUSH::Room'

    register_default_indexes with_unique_name: true

    def serializable_hash(options={})
      hash = super(options)
      hash[:room] = self.room_id
      hash
    end  
  end
end
    