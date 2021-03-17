# module AresMUSH
#   module Magic
#
#
#
#
#
#       # if name_string != nil
#       #   targets = Magic.parse_spell_targets(name_string, target_num)
#       # else
#       #   targets = []
#       # end
#       # messages = []
#       # if targets == "too_many_targets"
#       #   return [t('magic.too_many_targets', :spell => spell, :num => target_num)]
#       # elsif targets == "no_target"
#       #   return [t('magic.invalid_name')]
#       # elsif targets == []
#       #   if is_potion
#       #     message = t('magic.use_potion', :name => caster_name, :potion => spell)
#       #     messages.concat [message]
#       #   else
#       #     message = t('magic.casts_spell', :name => caster_name, :spell => spell, :mod => mod, :succeeds => success)
#       #     messages.concat [message]
#       #   end
#       # else
#
#
#         #   if ((damage_type == "Psionic" || damage_type == "Fire" || damage_type == "Cold") && !is_potion)
#         #     message = Magic.check_spell_vs_shields(target, caster_name, spell, mod, result)
#         #     if !message
#         #       names.concat [target.name]
#         #     else
#         #       messages.concat [message]
#         #     end
#         #   else
#         #     names.concat [target.name]
#         #   end
#         # end
#     end
#
#
#
#
#     # def self.cast_non_combat_heal(caster_name, name_string, spell, mod = nil, is_potion = false)
#     #   heal_points = Global.read_config("spells", spell, "heal_points")
#     #   if Character.named(caster_name)
#     #     caster = Character.named(caster_name)
#     #     caster_name = caster.name
#     #   else
#     #     #is an npc
#     #     caster = caster_name
#     #   end
#     #
#     #   if name_string != nil
#     #     targets = Magic.parse_spell_targets(name_string, spell)
#     #   else
#     #     targets = [caster]
#     #   end
#     #   if targets == "too_many_targets"
#     #     return [t('magic.too_many_targets', :spell => spell, :num => target_num)]
#     #   elsif targets == "no_target"
#     #     return [t('magic.invalid_name')]
#     #   else
#     #     messages = []
#     #     targets.each do |target|
#     #       wound = FS3Combat.worst_treatable_wound(target)
#     #       if (wound)
#     #         FS3Combat.heal(wound, heal_points)
#     #         if is_potion
#     #           message = [t('magic.potion_heal', :name => caster_name, :potion => spell, :target => target.name, :points => heal_points)]
#     #         else
#     #           message = [t('magic.cast_heal', :name => caster_name, :spell => spell, :mod => mod, :succeeds => "%xgSUCCEEDS%xn", :target => target.name, :points => heal_points)]
#     #         end
#     #       else
#     #         if is_potion
#     #           if caster_name == target.name
#     #             message = [t('magic.potion_heal', :name => caster_name, :potion => spell, :target => target.name, :points => heal_points)]
#     #           else
#     #             message = [t('magic.potion_heal_no_effect_target', :name => caster_name, :potion => spell, :target => target.name)]
#     #           end
#     #         else
#     #           message = [t('magic.cast_heal_no_effect', :name => caster_name, :spell => spell, :target => target.name, :mod => mod, :succeeds => "%xgSUCCEEDS%xn")]
#     #         end
#     #       end
#     #       messages.concat message
#     #     end
#     #     return messages
#     #   end
#     # end
#
#     # def self.cast_noncombat_shield(caster, caster_name, name_string, spell, mod, shield_strength, is_potion = false)
#     #   target_num = Global.read_config("spells", spell, "target_num") || 1
#     #   if name_string != nil
#     #
#     #     targets = Magic.parse_spell_targets(name_string, target_num)
#     #   else
#     #     targets = [caster]
#     #   end
#     #
#     #   if targets == "too_many_targets"
#     #     return [t('magic.too_many_targets', :spell => spell, :num => target_num)]
#     #   elsif targets == "no_target"
#     #     return [t('magic.invalid_name')]
#     #   else
#     #     messages = []
#     #     targets.each do |target|
#     #       if spell == "Mind Shield"
#     #         target.update(mind_shield: shield_strength)
#     #         type = "psionic"
#     #       elsif spell == "Endure Fire"
#     #         target.update(endure_fire: shield_strength)
#     #         type = "fire"
#     #       elsif spell == "Endure Cold"
#     #         target.update(endure_cold: shield_strength)
#     #         type = "ice"
#     #       end
#     #       if is_potion
#     #         Global.logger.info "#{spell} strength on #{target.name} set to #{shield_strength}."
#     #         message = [t('magic.potion_shield', :name => caster_name, :spell => spell, :mod => mod, :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => type)]
#     #         messages.concat message
#     #       else
#     #         Global.logger.info "#{spell} strength on #{target.name} set to #{shield_strength}."
#     #         message = [t('magic.cast_shield', :name => caster_name, :spell => spell, :mod => mod, :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => type)]
#     #         messages.concat message
#     #       end
#     #     end
#     #   end
#     #   return messages
#     # end
#
#
#   end
# end
