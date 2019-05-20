module AresMUSH
  class Character
    # Attributes for the RiM System.
    attribute :rim_xp, :type => DataType::Float, :default => 0
    attribute :rim_valor, :type => DataType::Integer, :default => 0
    attribute :rim_health, :type => DataType::Integer, :default => 0
    attribute :rim_mana, :type => DataType::Integer, :default => 0
    # Attributes that store multiple stats.
    collection :rim_attributes "AresMUSH::RiMAttribute"
    collection :rim_skills "AresMUSH::RiMSkill"
    collection :rim_spells "AresMUSH::RiMSpell"
    collection :rim_edges "AresMUSH::RiMEdge"
    collection :rim_talents "AresMUSH::RiMTalent"
    collection :rim_abilities "AresMUSH::RiMAbility"

    # Remove the stats?

    before_delete :delete_stats

    def delete_stats
      [ self.rim_attributes, self.rim_skills, self.rim_spells, self.rim_talents, self.rim_abilities, self.rim_edges].each do |list|
        list.each do |a|
          a.delete
        end
      end
  end
  def reset_xp
    self.update(rim_xp: 0)
  end
  def reset_mana
    self.update(rim_mana: 0)
  end
  def reset_health
    self.update(rim_health: 0)
  end
  def reset_valor
    self.update(rim_valor: 0)
  end

end
