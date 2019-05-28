module AresMUSH
  class Character
    attribute :console_level, :type => DataType::Integer, :default => 0
    attribute :console_experience, :type => DataType::Integer, :default => 0
    attribute :console_dmg_health, :type => DataType::Integer, :default => 0
    attribute :console_dmg_mana, :type => DataType::Integer, :default => 0
    attribute :console_dmg_stamina, :type => DataType::Integer, :default => 0
    attribute :console_oversoul, :type => DataType::Integer, :default => 0
    attribute :console_oversoul_type
    attribute :console_pool_health, :type => DataType::Integer, :default => 30
    attribute :console_pool_mana, :type => DataType::Integer, :default => 30
    attribute :console_pool_stamina, :type => DataType::Integer, :default => 30
    attribute :console_cgen, :type => DataType::Integer, :default => 0
    attribute :console_pool_limit, :type => DataType::Integer, :default => 0

    collection :console_patience, "AresMUSH::ConsolePatience"
    collection :console_attributes, "AresMUSH::ConsoleAttribute"
    collection :console_skills, "AresMUSH::ConsoleAbility"
    collection :console_inventory,"AresMUSH::ConsoleInventory"
    collection :console_equipped, "AresMUSH::ConsoleEquipped"
    collection :console_huntlog, "AresMUSH::ConsoleHuntLog"
    collection :console_questlog, "AresMUSH::ConsoleQuestLog"
    collection :console_companion, "AresMUSH::ConsoleCompanion"
    collection :console_status, "AresMUSH::ConsoleStatus"
    collection :console_recipes, "AresMUSH::ConsoleRecipe"

    before_delete :delete_abilities
   def delete_abilities
     [ self.console_patience, self.console_attributes, self.console_skills, self.console_inventory, self.console_equipped, self.console_huntlog, self.console_questlog, self.console_companion, self.console_status ].each do |list|
       list.each do |a|
         a.delete
       end
      end
    end

   def is_quick_learner
     self.has_ability(self, "Quick Growth")
   end

   def has_ability(char, ability_name)
     ab = SuperConsole.find_ability(char, ability_name)
     if (!ab)
       false
     else
       true
     end
   end

   def level
     self.console_level
   end

   def health_stat
     self.console_pool_health.to_i
   end

   def limit_bar
      unused = "%X166 %xn"
      used = "%X242 %xn"
      dmg = self.console_pool_limit / 2
      left = (100 - dmg) / 2
      dmgnum = dmg.to_f.floor
      leftnum = left.to_f.floor
      orange = unused.repeat(dmgnum)
      gray = used.repeat(leftnum)
      gray + orange
    end

   def health_bar
      unused = "%X1 %xn"
      used = "%X242 %xn"
      dmg = self.console_dmg_health / 2
      left = (100 - dmg) / 2
      dmgnum = dmg.to_f.floor
      leftnum = left.to_f.floor
      red = unused.repeat(leftnum)
      gray = used.repeat(dmgnum)
      red + gray
    end

    def mana_bar
       unused = "%X26 %xn"
       used = "%X242 %xn"
       dmg = self.console_dmg_mana / 2
       left = (100 - dmg) / 2
       dmgnum = dmg.to_f.floor
       leftnum = left.to_f.floor
       blue = unused.repeat(leftnum)
       gray = used.repeat(dmgnum)
       blue + gray
     end

     def stamina_bar
        unused = "%X142 %xn"
        used = "%X242 %xn"
        dmg = self.console_dmg_stamina / 2
        left = (100 - dmg) / 2
        dmgnum = dmg.to_f.floor
        leftnum = left.to_f.floor
        yellow = unused.repeat(leftnum)
        gray = used.repeat(dmgnum)
        yellow + gray
      end
  end
end
