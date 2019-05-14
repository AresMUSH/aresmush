module AresMUSH
  class Portal < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :name_upcase
    index :name_upcase
    attribute :primary_school
    attribute :all_schools, :type => DataType::Array, :default => []
    attribute :creatures, :type => DataType::Array, :default => []
    attribute :npcs, :type => DataType::Array, :default => []
    attribute :gms, :type => DataType::Array, :default => []
    attribute :location
    attribute :description
    attribute :trivia
    attribute :events


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

    def update_portal(key, value)
      name = key.to_s.downcase
      if (name == "name")
        self.update(name: value)
        self.update(name_upcase: value.upcase)
      elsif (name == "primary_school")
        self.update(primary_school: value)
      elsif (name == "all_schools")
        all_schools = self.all_schools
        new_all_schools = all_schools.concat [value]
        self.update(all_schools: new_all_schools)
      elsif (name == "creatures")
        all_schools = self.all_schools
        new_all_schools = all_schools.concat [value]
        self.update(all_schools: new_all_schools)
      elsif (name == "npcs")
        npcs = self.npcs
        new_npcs = npcs.concat [value]
        self.update(npcs: new_npcs)
      elsif (name == "gms")
        gms = self.gms
        new_gms = gms.concat [value]
        self.update(gms: gms)
      elsif (name == "description")
        self.update(description: value)
      elsif (name == "trivia")
        self.update(trivia: value)
      elsif (name == "events")
        self.update(events: value)
      elsif (name == "location")
        self.update(location: value)
      end
    end


  end
end
