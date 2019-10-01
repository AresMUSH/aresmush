# module AresMUSH
#   module FS3Combat
#     class PotionTargetAction < CombatAction
#       attr_accessor  :spell, :target, :names
#       def prepare
#         if (self.action_args =~ /\//)
#           #Uses 'spell' instead of potion for easy c/p. Spell == potion.
#           self.names = self.action_args.before("/")
#           self.spell = self.action_args.after("/")
#         else
#           self.names = self.name
#           self.spell = self.action_args
#         end
#
#         error = self.parse_targets(self.names)
#         return error if error
#
#         return t('fs3combat.only_one_target') if (self.targets.count > 1)
#       end
#
#       def print_action
#         msg = t('custom.potion_action_target_msg_long', :name => self.name, :potion => self.spell, :target => print_target_names)
#       end
#
#       def print_action_short
#         t('custom.potion_action_msg_short')
#       end
#
#       def resolve
#         messages = []
#         weapon = Global.read_config("spells", self.spell, "weapon")
#         weapon_specials_str = Global.read_config("spells", self.spell, "weapon_specials")
#         armor = Global.read_config("spells", self.spell, "armor")
#         armor_specials_str = Global.read_config("spells", self.spell, "armor_specials")
#         heal_points = Global.read_config("spells", self.spell, "heal_points")
#         lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
#         attack_mod = Global.read_config("spells", self.spell, "attack_mod")
#         defense_mod = Global.read_config("spells", self.spell, "defense_mod")
#         spell_mod = Global.read_config("spells", self.spell, "spell_mod")
#         stance = Global.read_config("spells", self.spell, "stance")
#         roll = Global.read_config("spells", self.spell, "roll")
#
#
#         targets.each do |target|
#
#           #Healing
#           if heal_points
#             wound = FS3Combat.worst_treatable_wound(target.associated_model)
#
#             if (wound)
#               FS3Combat.heal(wound, heal_points)
#               if target.death_count > 0
#                 messages.concat [t('custom.potion_heal_ko_target', :name => self.name, :potion => self.spell, :points => heal_points, :target => print_target_names)]
#               else
#                 messages.concat [t('custom.potion_heal_target', :name => self.name, :potion => self.spell, :points => heal_points, :target => print_target_names)]
#               end
#             else
#                messages.concat [t('custom.potion_heal_no_effect_target', :name => self.name, :potion => self.spell, :target => print_target_names)]
#             end
#             target.update(death_count: 0  )
#           end
#
#           #Equip Weapon
#           if weapon
#             FS3Combat.set_weapon(combatant, target, weapon)
#             if armor
#
#             else
#               messages.concat [t('custom.use_potion_target', :name => self.name, :potion => self.spell, :target => print_target_names)]
#             end
#           end
#
#           #Equip Weapon Specials
#           if weapon_specials_str
#             weapon_specials = weapon_specials_str ? weapon_specials_str.split('+') : nil
#             FS3Combat.set_weapon(combatant, target, target.weapon, weapon_specials)
#             if heal_points
#
#             elsif lethal_mod || defense_mod || attack_mod || spell_mod
#
#             else
#               messages.concat [t('custom.use_potion_target', :name => self.name, :potion => self.spell, :target => print_target_names)]
#             end
#           end
#
#           #Equip Armor
#           if armor
#             FS3Combat.set_armor(combatant, target, armor)
#             messages.concat [t('custom.use_potion_target', :name => self.name, :potion => self.spell, :target => print_target_names)]
#           end
#
#           #Equip Armor Specials
#           if armor_specials_str
#             armor_specials = armor_specials_str ? armor_specials_str.split('+') : nil
#             FS3Combat.set_armor(combatant, target, target.armor, armor_specials)
#             messages.concat [t('custom.use_potion_target', :name => self.name, :potion => self.spell, :target => print_target_names)]
#           end
#
#
#           #Apply Mods
#           if lethal_mod
#             current_mod = target.damage_lethality_mod
#             new_mod = current_mod + lethal_mod
#             target.update(damage_lethality_mod: new_mod)
#             messages.concat [t('custom.potion_mod_target', :name => self.name, :potion => self.spell, :target => print_target_names, :mod => target.spell_mod, :type => "spell")]
#           end
#
#           if attack_mod
#             current_mod = target.attack_mod
#             new_mod = current_mod + attack_mod
#             target.update(attack_mod: new_mod)
#             messages.concat [t('custom.potion_mod_target', :name => self.name, :potion => self.spell, :target => print_target_names, :mod => target.attack_mod, :type => "attack")]
#           end
#
#           if defense_mod
#             current_mod = target.defense_mod
#             new_mod = current_mod + defense_mod
#             target.update(defense_mod: new_mod)
#             messages.concat [t('custom.potion_mod_target', :name => self.name, :potion => self.spell, :target => print_target_names, :mod => target.defense_mod, :type => "defense")]
#           end
#
#           if spell_mod
#             current_mod = target.spell_mod
#             new_mod = current_mod + spell_mod
#             target.update(spell_mod: new_mod)
#             messages.concat [t('custom.potion_mod_target', :name => self.name, :potion => self.spell, :target => print_target_names, :mod => target.spell_mod, :type => "spell")]
#           end
#
#           #Change Stance
#           if stance
#             target.update(stance: stance)
#             messages.concat [t('custom.potion_stance_target', :name => self.name, :potion => self.spell, :stance => stance, :target => print_target_names)]
#           end
#
#           #Roll
#           if roll
#             succeeds = Custom.roll_combat_spell_success(self.combatant, self.spell)
#             messages.concat [t('custom.potion_action_target_resolution_msg_long', :name => self.name, :potion => self.spell, :target => print_target_names)]
#           end
#
#           if !combatant.is_npc?
#             potion = Custom.find_potion_has(combatant.associated_model, self.spell)
#             potion.delete
#           end
#
#         end
#
#         messages
#
#       end
#     end
#   end
# end
