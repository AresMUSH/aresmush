module AresMUSH
  class Portal < Ohm::Model
    include ObjectModel
    include FindByName

    attribute :name
    attribute :name_upcase
    index :name_upcase
    attribute :primary_school, :type => DataType::Hash, :default => {}
    attribute :all_schools, :type => DataType::Array, :default => []
    attribute :other_creatures
    attribute :npcs
    attribute :location
    attribute :description
    attribute :trivia
    attribute :events
    attribute :pinterest
    attribute :society
    before_save :save_upcase

    set :gms, "AresMUSH::Character"
    set :creatures, "AresMUSH::Creature"

    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end

    # def gm_names
    #   self.gmd.sort { |gm| gm.name }.map { |gm| gm.name }
    # end

    def self.find_any_by_name(name_or_id)
      return [] if !name_or_id

      if (name_or_id.start_with?("#"))
        return find_any_by_id(name_or_id)
      end

      find(name_upcase: name_or_id.upcase).to_a
    end

    def self.find_one_by_name(name_or_id)
      portal = Portal[name_or_id]
      return portal if portal

      find_any_by_name(name_or_id).first
    end

    def self.named(name)
      find_one_by_name(name)
    end


  end
end
