module AresMUSH
  class Creature < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :name_upcase
    index :name_upcase
    attribute :major_school, :type => DataType::Hash, :default => {}
    attribute :minor_school, :type => DataType::Hash, :default => {}
    attribute :sapient, :type => DataType::Boolean, :default => false
    attribute :language
    attribute :traits
    attribute :society
    attribute :magical_abilities
    attribute :events
    attribute :pinterest
    attribute :found


    set :gms, "AresMUSH::Character"
    set :portals, "AresMUSH::Portal"

    def self.find_any_by_name(name_or_id)
      return [] if !name_or_id

      if (name_or_id.start_with?("#"))
        return find_any_by_id(name_or_id)
      end

      find(name_upcase: name_or_id.upcase).to_a
    end

    def self.find_one_by_name(name_or_id)
      creature = Creature[name_or_id]
      return creature if creature

      find_any_by_name(name_or_id).first
    end

    def self.named(name)
      find_one_by_name(name)
    end

  end
end
