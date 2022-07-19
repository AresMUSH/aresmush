module AresMUSH
  class Combatant
    #SPELLS

    attribute :magic_stun, :type => DataType::Boolean, :default => false
    attribute :magic_stun_spell
    attribute :magic_stun_counter, :type => DataType::Integer, :default => 0
    attribute :death_count, :type => DataType::Integer, :default => 0
    attribute :magic_stance_spell
    attribute :magic_stance_counter, :type => DataType::Integer, :default => 0

    attribute :magic_weapon_effects, :type => DataType::Hash, :default => {}
    attribute :magic_armor_effects, :type => DataType::Hash, :default => {}

    attribute :gm_spell_mod, :type => DataType::Integer, :default => 0

    #Spell mods are separate from GM-set mods
    attribute :spell_mod, :type => DataType::Integer, :default => 0
    attribute :spell_mod_counter, :type => DataType::Integer, :default => 0
    attribute :magic_init_mod, :type => DataType::Integer, :default => 0
    attribute :magic_init_mod_counter, :type => DataType::Integer, :default => 0
    attribute :magic_lethal_mod, :type => DataType::Integer, :default => 0
    attribute :magic_lethal_mod_counter, :type => DataType::Integer, :default => 0
    attribute :magic_defense_mod, :type => DataType::Integer, :default => 0
    attribute :magic_defense_mod_counter, :type => DataType::Integer, :default => 0
    attribute :magic_attack_mod, :type => DataType::Integer, :default => 0
    attribute :magic_attack_mod_counter, :type => DataType::Integer, :default => 0




  end
end
