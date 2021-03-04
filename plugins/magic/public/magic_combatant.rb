module AresMUSH
  class Combatant
    #SPELLS
    attribute :spell_mod, :type => DataType::Integer, :default => 0
    attribute :gm_spell_mod, :type => DataType::Integer, :default => 0
    attribute :has_cast, :type => DataType::Boolean, :default => false
    attribute :magic_stun, :type => DataType::Boolean, :default => false
    attribute :magic_stun_spell
    attribute :magic_stun_counter, :type => DataType::Integer, :default => 0
    attribute :death_count, :type => DataType::Integer, :default => 0
    attribute :spell_weapon_effects, :type => DataType::Hash, :default => {}
    attribute :spell_armor_effects, :type => DataType::Hash, :default => {}
    attribute :spell_mod_counter, :type => DataType::Integer, :default => 0
    attribute :init_spell_mod, :type => DataType::Integer, :default => 0
    attribute :init_spell_mod_counter, :type => DataType::Integer, :default => 0
    attribute :spell_damage_lethality_mod, :type => DataType::Integer, :default => 0
    attribute :spell_defense_mod, :type => DataType::Integer, :default => 0
    attribute :spell_attack_mod, :type => DataType::Integer, :default => 0
    attribute :lethal_mod_counter, :type => DataType::Integer, :default => 0
    attribute :attack_mod_counter, :type => DataType::Integer, :default => 0
    attribute :defense_mod_counter, :type => DataType::Integer, :default => 0
    attribute :stance_counter, :type => DataType::Integer, :default => 0
    attribute :stance_spell
    attribute :mind_shield, :type => DataType::Integer, :default => 0
    attribute :mind_shield_counter, :type => DataType::Integer, :default => 0
    attribute :endure_fire, :type => DataType::Integer, :default => 0
    attribute :endure_fire_counter, :type => DataType::Integer, :default => 0
    attribute :endure_cold, :type => DataType::Integer, :default => 0
    attribute :endure_cold_counter, :type => DataType::Integer, :default => 0

    # def auto_revive?
    #     return true if combatant.associated_model.spells_learned.select { |a| (a.auto_revive? == true)}
    # end

  end
end
