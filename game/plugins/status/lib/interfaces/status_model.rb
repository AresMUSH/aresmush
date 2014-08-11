module AresMUSH
  class Character
    field :status, :type => String, :default => "NEW"
    field :last_ic_location_id, :type => Moped::BSON::ObjectId
    field :afk_message, :type => String
    
    # TODO - move to demographics
    def possessive_pronoun
      "her"
    end
  end
end