module AresMUSH

  class Character < Ohm::Model
    collection :luck_record, "AresMUSH::LuckRecord"
    before_delete :delete_luck_record

    def delete_luck_record
      luck_record.each { |r| r.delete }
    end
  end
end


class LuckRecord < Ohm::Model
  include ObjectModel

  index :character
  reference :character, "AresMUSH::Character"
  attribute :reason
  attribute :from

end
