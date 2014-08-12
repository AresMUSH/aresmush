module AresMUSH
  class Character
    field :status, :type => String, :default => "NEW"
    field :last_ic_location_id, :type => Moped::BSON::ObjectId
    field :afk_message, :type => String
    
    def is_approved?
      self.status != "NEW"
    end
  end
end