
module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end




      def handle
        combatant = enactor.combatant
        if !combatant.spell_weapon_effects.empty?
          weapon_effects = combatant.spell_weapon_effects
          client.emit "Old hash: #{weapon_effects}"
          weapon_effects.each do |weapon, effects|
            effects.each do |effect, rounds|
              new_rounds = rounds - 1
              if new_rounds == 0
                weapon_effects[weapon].delete(effect)
                if weapon_effects[weapon].empty?
                  weapon_effects.delete(weapon)
                end
              else
                weapon_effects[weapon][effect] = new_rounds
              end
              combatant.update(spell_weapon_effects: weapon_effects)

            end
          end
          client.emit "New hash: #{weapon_effects}"







        end
      end





    end
  end
end
