module AresMUSH
  class Room
    include ObjectModel

    has_many :exits, :class_name => 'AresMUSH::Exit', :foreign_key => :source_id, :inverse_of => "source_id", :dependent => :destroy
    has_many :characters, :class_name => 'AresMUSH::Character', :inverse_of => "room_id"

    register_default_indexes

    def serializable_hash(options={})
      hash = super(options)
      hash[:exits] = exits.map { |e| e.id }
      hash
    end
  end
end
