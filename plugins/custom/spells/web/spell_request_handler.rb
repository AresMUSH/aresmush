module AresMUSH
  module Custom
    class SpellRequestHandler
      def handle(request)
        spell_list = Global.read_config("spells")

        {

          desc: Global.read_config("spells", spell, "desc"),
          available: Global.read_config("spells", spell, "available"),
          level: Global.read_config("spells", spell, "level"),
          school: Global.read_config("spells", spell, "school"),
          potion: Global.read_config("spells", spell, "is_potion"),
          duration: Global.read_config("spells", spell, "duration"),
          casting_time: Global.read_config("spells", spell, "casting_time"),
          range: Global.read_config("spells", spell, "range"),
          los: Global.read_config("spells", spell, "line_of_sight"),
          area: Global.read_config("spells", spell, "area"),
          targets:  Global.read_config("spells", spell, "target_num"),
          heal: Global.read_config("spells", spell, "heal_points"),
          defense_mod: Global.read_config("spells", spell, "defense_mod"),
          attack_mod:  Global.read_config("spells", spell, "attack_mod"),
          lethal_mod: Global.read_config("spells", spell, "attack_mod"),
          spell_mod: Global.read_config("spells", spell, "spell_mod"),
          weapon: Global.read_config("spells", spell, "weapon"),
          armor: Global.read_config("spells", spell, "armor")

        }

      end

    end
  end
end
