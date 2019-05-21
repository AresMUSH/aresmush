module AresMUSH
  class Character
    attribute :console_level, :type => DataType::Integer, :default => 1
    attribute :console_experience, :type => DataType::Integer, :default => 0
    attribute :console_dmg_health, :type => DataType::Integer, :default => 0
    attribute :console_dmg_mana, :type => DataType::Integer, :default => 0
    attribute :console_dmg_stamina, :type => DataType::Integer, :default => 0
    attribute :console_oversoul, :type => DataType::Integer, :default => 0
    attribute :console_oversoul_type

    collection :console_patience, "AresMUSH::ConsolePatience"
    collection :console_attributes, "AresMUSH::ConsoleAttribute"
    collection :console_skills, "AresMUSH::ConsoleAbility"
    collection :console_inventory,"AresMUSH::ConsoleInventory"
    collection :console_equipped, "AresMUSH::ConsoleEquipped"
    collection :console_huntlog, "AresMUSH::ConsoleHuntLog"
    collection :console_questlog, "AresMUSH::ConsoleQuestLog"
    collection :console_companion, "AresMUSH::ConsoleCompanion"
    collection :console_status, "AresMUSH::ConsoleStatus"


    before_delete :delete_abilities
     def delete_abilities
       [ self.console_patience, self.console_attributes, self.console_skills, self.console_inventory, self.console_equipped, self.console_huntlog, self.console_questlog, self.console_companion, self.console_status ].each do |list|
         list.each do |a|
           a.delete
         end
       end
     end
  end
   def health_bar
      unused = "%X1 %xn"
      used = "%X242 %xn"
      dmg = self.console_dmg_health / 2
      left = (100 - dmg) / 2
      good = unused.floor.repeat(left)
      bad = used.floor.repeat(dmg)
      good + bad
    end
    def self.show_health
      health_bar
    end
end
