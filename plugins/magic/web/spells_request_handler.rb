module AresMUSH
  module Magic
    class SpellsRequestHandler

      def handle(request)
        Global.logger.debug "CALLING CORRECT HANDLER."
        all_spells = Global.read_config("spells")
        spells = build_list(all_spells)
        spells.each do |s|
          weapon = Global.read_config("spells", s[:name], "weapon")
          weapon_specials = Global.read_config("spells", s[:name], "weapon_specials")
          armor = Global.read_config("spells", s[:name], "armor")
          armor_specials = Global.read_config("spells", s, "armor_specials")
          attack = Global.read_config("spells", s[:name], "attack_mod")
          lethal = Global.read_config("spells", s[:name], "lethal_mod")
          spell = Global.read_config("spells", s[:name], "spell_mod")
          defense = Global.read_config("spells", s[:name], "defense_mod")
          if s[:level] == 8
            s[:level_8] = true
            s[:xp] = 13
          elsif s[:level] == 7
            s[:xp] = 11
          elsif s[:level] == 6
            s[:xp] = 9
          elsif s[:level] == 5
            s[:xp] = 9
          elsif s[:level] == 4
            s[:xp] = 5
          elsif s[:level] == 3
            s[:xp] = 5
          elsif s[:level] == 2
            s[:xp] = 3
          elsif s[:level] == 1
            s[:xp] = 2
          end
          if s[:range] == "Massive"
            s[:range_desc] = "(2 miles)"
          elsif s[:range] == "Short"
            s[:range_desc] = "(10 yards)"
          elsif s[:range] == "Long"
            s[:range_desc] = "(100 yards)"
          end
          s[:weapon_lethality] = FS3Combat.weapon_stat(weapon, "lethality")
          s[:weapon_penetration] = FS3Combat.weapon_stat(weapon, "penetration")
          s[:weapon_type] = FS3Combat.weapon_stat(weapon, "weapon_type")
          s[:weapon_accuracy] = FS3Combat.weapon_stat(weapon, "accuracy")
          s[:weapon_shrapnel] = FS3Combat.weapon_stat(weapon, "has_shrapnel")
          s[:weapon_init] = FS3Combat.weapon_stat(weapon, "init_mod")
          s[:weapon_damage_type] = FS3Combat.weapon_stat(weapon, "damage_type")
          if weapon_specials
            weapon_special = "Spell+#{weapon_specials}"
            s[:weapon_special_lethality] = FS3Combat.weapon_stat(weapon_special, "lethality")
            s[:weapon_special_penetration] = FS3Combat.weapon_stat(weapon_special, "penetration")
            s[:weapon_special_init] = FS3Combat.weapon_stat(weapon_special, "init_mod")
            s[:weapon_special_accuracy] = FS3Combat.weapon_stat(weapon_special, "accuracy")
          end
          if (attack || defense || lethal || spell)
            s[:mod] = true
          end
          protection = FS3Combat.armor_stat(armor, "protection")
          if protection
            protection = protection["Chest"]
          end
          s[:armor_protection] = protection
          s[:armor_defense] = FS3Combat.armor_stat(armor, "defense")
          if s[:targets] == nil

          elsif s[:targets] == 1
            s[:single_target] = true
          elsif s[:targets] > 1
            s[:multi_target] = true
          end
        end

        spells_by_level = spells.group_by { |s| s[:level] }

        {
          spells: spells_by_level,
          title: "All Spells",
        }

      end


      def build_list(hash)
        hash.sort.map { |name, data| {
          key: name,
          name: name.titleize,
          desc: Website.format_markdown_for_html(data['desc']),
          available: data['available'],
          level: data['level'],
          school: data['school'],
          potion: data['is_potion'],
          duration: data['duration'],
          casting_time: data['casting_time'],
          range: data['range'],
          area: data['area'],
          los: data['line_of_sight'],
          targets: data['target_num'],
          heal: data['heal_points'],
          defense_mod: data['defense_mod'],
          attack_mod: data['attack_mod'],
          lethal_mod: data['lethal_mod'],
          spell_mod: data['spell_mod'],
          weapon: data['weapon'],
          armor: data['armor'],
          armor_specials: data['armor_specials'],
          weapon_specials: data['weapon_specials'],
          effect: data['effect'],
          damage_type: data['damage_type']

          }
        }
      end

    end
  end
end
