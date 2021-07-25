module AresMUSH
  class Character 
    attribute :species
    attribute :xp, :type => DataType::Integer, :default => 0
    attribute :luck_points, :type => DataType::Integer, :default => 0
    attribute :action_points, :type => DataType::Integer, :default => 2
    attribute :hit_points, :type => DataType::Integer, :default => 0
    attribute :power_points, :type => DataType::Integer, :default => 0
    attribute :hitloc_hp, :type => DataType::Hash, :default => {}
    attribute :heal_rate, :type => DataType::Integer, :default => 0
    attribute :damage_mod
    attribute :movement_rate, :type => DataType::Integer, :default => 0
    attribute :creds, :type => DataType::Integer, :default => 0
   
    collection :skills, "AresMUSH::MSkill"
    collection :characteristics, "AresMUSH::MCharacteristic"

    before_delete :delete_collections

    def delete_collections
      [self.skills, self.characteristics].each do |list|
        list.each { |c| c.delete }
      end
    end
  end
end