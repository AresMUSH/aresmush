module AresMUSH
  class Character
    collection :spells_learned, "::SpellsLearned"
    collection :magic_shields, "AresMUSH::MagicShields"
    attribute :spells_cast, :type => DataType::Integer
    attribute :achievement_spells_learned, :type => DataType::Integer
    attribute :achievement_spells_discarded, :type => DataType::Integer
    attribute :dead, :type => DataType::Boolean, :default => false
    attribute :has_died, :type => DataType::Integer

    #Delete these eventually
    attribute :mind_shield, :type => DataType::Integer, :default => 0
    attribute :endure_fire, :type => DataType::Integer, :default => 0
    attribute :endure_cold, :type => DataType::Integer, :default => 0

    before_delete :clear_magic

    def clear_magic
      self.magic_shields.each { |s| s.delete }
      self.spells_learned.each { |s| s.delete }
    end

    def auto_revive?
      auto_revive_spell = self.spells_learned.to_a.select { |spell| spell.learning_complete && Global.read_config("spells", spell.name, "auto_revive")}
      return auto_revive_spell[0].name  if !auto_revive_spell.empty?
    end

  end
end
