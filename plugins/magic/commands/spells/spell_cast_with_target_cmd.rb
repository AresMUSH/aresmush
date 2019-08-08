# module AresMUSH
#   module Magic
#     class SpellCastWithTargetCmd
#       include CommandHandler
#       attr_accessor :name, :target, :target_name, :target_combat, :spell, :spell_list, :caster, :caster_combat, :action_args, :mod
#
#       def parse_args
#         self.spell_list = Global.read_config("spells")
#         if (cmd.args =~ /\//)
#           #Forcing NPC or PC to cast
#           args = cmd.parse_args( /(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=?(?<arg3>.+)?/)
#           combat = enactor.combat
#           caster_name = titlecase_arg(args.arg1)
#           self.spell = titlecase_arg(args.arg2)
#           self.target_name = titlecase_arg(args.arg3)
#           #Returns char or NPC
#           self.caster = FS3Combat.find_named_thing(caster_name, enactor)
#           # self.target = FS3Combat.find_named_thing(target_name, enactor)
#
#           #Returns combatant
#           if enactor.combat
#             # self.target_combat = combat.find_combatant(self.target_name)
#             self.caster_combat = combat.find_combatant(caster_name)
#           end
#
#         else
#           #Enactor casts
#           args = cmd.parse_args(/(?<arg1>[^\=]+)\=?(?<arg2>[^\+\-]+)(?<arg3>.+)?/)
#           self.spell = titlecase_arg(args.arg1)
#           self.target_name = titlecase_arg(args.arg2)
#           self.mod = args.arg3
#
#           #Returns char or NPC
#           self.caster = enactor
#           self.target = FS3Combat.find_named_thing(self.target_name, self.caster)
#
#           #Returns combatant
#           if enactor.combat
#             combat = enactor.combat
#             self.caster_combat = enactor.combatant
#             self.target_combat = combat.find_combatant(target_name)
#           end
#         end
#         arg_array = [self.target_name, self.spell]
#         self.action_args = arg_array.join("/")
#       end
#
#       def check_errors
#         return t('magic.not_character') if !caster
#         return t('magic.not_spell') if !self.spell_list.include?(self.spell)
#         target_optional = Global.read_config("spells", self.spell, "target_optional")
#         return t('magic.doesnt_use_target') if !target_optional
#         is_res = Global.read_config("spells", self.spell, "is_res")
#         is_revive = Global.read_config("spells", self.spell, "is_revive")
#         target_names = target_name.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
#         if enactor.combat
#           return t('magic.spell_ko') if self.caster_combat.is_ko
#           return t('magic.dont_know_spell') if (!caster_combat.is_npc? &&  Magic.knows_spell?(caster, self.spell) == false && !Magic.item_spells(caster).include(spell)
#           return t('fs3combat.must_escape_first') if caster_combat.is_subdued?
#
#           target_names.each do |name|
#             target = enactor.combat.find_combatant(name)
#             return t('fs3combat.not_in_combat', :name => name) if !target
#             return t('magic.not_dead', :target => target.name) if (is_res && !target.associated_model.dead)
#             return t('magic.not_ko', :target => target.name) if (is_revive && !target.is_ko)
#             Check that weapon specials can be added to weapon
#             weapon_specials_str = Global.read_config("spells", self.spell, "weapon_specials")
#             if weapon_specials_str
#               weapon_special_group = FS3Combat.weapon_stat(target.weapon, "special_group") || ""
#               weapon_allowed_specials = Global.read_config("fs3combat", "weapon special groups", weapon_special_group) || []
#               return t('magic.cant_cast_on_gear', :spell => self.spell, :target => target.name, :gear => "weapon") if !weapon_allowed_specials.include?(weapon_specials_str.downcase)
#             end
#             #Check that armor specials can be added to weapon
#             armor_specials_str = Global.read_config("spells", self.spell, "armor_specials")
#             if armor_specials_str
#               armor_allowed_specials = FS3Combat.armor_stat(target.armor, "allowed_specials") || []
#               return t('magic.cant_cast_on_gear', :spell => self.spell, :target => target.name, :gear => "armor") if !armor_allowed_specials.include?(armor_specials_str)
#             end
#           end
#         else
#           target_names.each do |name|
#             target = Character.named(name)
#             return t('magic.not_character', :name => name) if !target
#           end
#           return t('magic.dont_know_spell') if (Magic.knows_spell?(caster, self.spell) == false && !Magic.item_spells(caster).include(spell)
#         end
#
#
#         weapon = Global.read_config("spells", self.spell, "weapon")
#         return t('fs3combat.invalid_weapon') if (weapon && !FS3Combat.weapon(weapon))
#         armor = Global.read_config("spells", self.spell, "armor")
#         return t('fs3combat.invalid_armor') if (armor && !FS3Combat.armor(armor))
#
#         return t('magic.caster_should_not_equal_target') if (self.caster.combat && self.caster_combat == self.target_combat)
#
#         return nil
#       end
#
#       def handle
#       #Reading Config Files
#         rounds = Global.read_config("spells", self.spell, "rounds")
#         heal_points = Global.read_config("spells", self.spell, "heal_points")
#         weapon = Global.read_config("spells", self.spell, "weapon")
#         fs3_attack = Global.read_config("spells", self.spell, "fs3_attack")
#         roll = Global.read_config("spells", self.spell, "roll")
#         is_stun = Global.read_config("spells", self.spell, "is_stun")
#
#         if self.caster.combat
#
#           if fs3_attack
#             if weapon
#               FS3Combat.emit_to_combat caster_combat.combat, t('magic.will_cast_fs3_attack', :name => caster_combat.name, :spell => spell, :target => target_name), nil, true
#               FS3Combat.set_weapon(enactor, caster_combat, weapon)
#               weapon_type = FS3Combat.weapon_stat(caster_combat.weapon, "weapon_type")
#               if weapon_type == "Explosive"
#                 FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::ExplodeAction, target_name)
#               elsif weapon_type == "Suppressive"
#                 FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::SuppressAction, target_name)
#               else
#                 FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::AttackAction, target_name)
#               end
#             end
#           elsif is_stun
#             FS3Combat.set_weapon(enactor, caster_combat, weapon)
#             FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::SpellStunAction, self.action_args)
#           else
#             FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::SpellAction, self.action_args)
#           end
#           if !caster_combat.is_npc?
#             Magic.handle_spell_cast_achievement(self.caster)
#           end
#
#         else
#         #NonCombat
#           effect = Global.read_config("spells", self.spell, "effect")
#           success = Magic.roll_noncombat_spell_success(self.caster, self.spell, self.mod)
#           if success == "%xgSUCCEEDS%xn"
#             if heal_points
#               message = Magic.cast_non_combat_heal(self.caster, self.target_name, self.spell, self.mod)
#             elsif Magic.spell_shields.include?(self.spell)
#               message = Magic.cast_noncombat_shield(self.caster, self.target, self.spell, self.mod)
#             else
#               message = Magic.cast_noncombat_spell(self.caster, self.target_name, self.spell, self.mod)
#
#             end
#             Magic.handle_spell_cast_achievement(self.caster)
#           else
#             #Spell doesn't succeed
#             message = t('magic.casts_spell', :name => self.caster.name, :spell => self.spell, :succeeds => success)
#           end
#             self.caster.room.emit message
#             if self.caster.room.scene
#               Scenes.add_to_scene(self.caster.room.scene, message)
#             end
#         end
#
#       end
#
#
#
#     end
#   end
# end
