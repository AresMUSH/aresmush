module AresMUSH
  class Character
    attribute :console_level, :type => DataType::Integer, :default => 1
    attribute :console_experience, :type => DataType::Integer, :default => 0
    attribute :console_dmg_health, :type => DataType::Integer, :default => 0
    attribute :console_dmg_mana, :type => DataType::Integer, :default => 0
    attribute :console_oversoul, :type => DataType::Integer, :default => 0
    attribute :console_oversoul_type

    collection :console_patience, "AresMUSH::ConsolePatience"
    collection :console_attributes, "AresMUSH::ConsoleAttribute"
    collection :console_abilities, "AresMUSH::ConsoleAbility"
    collection :console_castables, "AresMUSH::ConsoleCastable"
    collection :console_actions, "AresMUSH::ConsoleAction"
    collection :console_inventory,"AresMUSH::ConsoleInventory"
    collection :console_equipped, "AresMUSH::ConsoleEquipped"
    collection :console_huntlog, "AresMUSH::ConsoleHuntLog"
    collection :console_questlog, "AresMUSH::ConsoleQuestLog"
    collection :console_companion, "AresMUSH::ConsoleCompanion"
    collection :console_status, "AresMUSH::ConsoleStatus"

  end
end
