module AresMUSH
  module Magic
    class SearchSpellsRequestHandler
      def handle(request)
        Global.logger.debug "REQUEST: #{request}"
        searchName = (request.args[:searchName] || "").strip
        searchLevel = (request.args[:searchLevel] || "").strip.to_i
        searchSchool = (request.args[:searchSchool] || "").strip
        searchEffect = (request.args[:searchEffect] || "").strip
        searchDesc = (request.args[:searchDesc] || "").strip
        searchAvailable = (request.args[:searchAvailable] || "")
        searchPotion = (request.args[:searchPotion] || "")
        searchLOS = (request.args[:searchLOS] || "")

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
            s[:xp] = 12
          elsif s[:level] == 7
            s[:xp] = 8
          elsif s[:level] == 6
            s[:xp] = 7
          elsif s[:level] == 5
            s[:xp] = 6
          elsif s[:level] == 4
            s[:xp] = 5
          elsif s[:level] == 3
            s[:xp] = 4
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


        # spells = spells.group_by { |s| s[:level] }

        if (!searchName.blank?)
          spells = spells.select { |s| s[:name] =~ /\b#{searchName}\b/i }
        end

        if searchLevel != 0
          spells = spells.select { |s| s[:level] == searchLevel }
        end

        if (!searchSchool.blank?)
          spells = spells.select { |s| s[:school] =~ /\b#{searchSchool}\b/i }
        end

        if (!searchEffect.blank?)
          spells = spells.select { |s| s[:effect] =~ /\b#{searchEffect}\b/i }
        end

        if (!searchDesc.blank?)
          spells = spells.select { |s| s[:desc] =~ /\b#{searchDesc}\b/i }
        end

        if searchAvailable == "true"
          spells = spells.select { |s| s[:available] == true }
        end

        if searchPotion == "true"
          spells = spells.select { |s| s[:potion] == true }
        end

        if searchLOS == "true"
          spells = spells.select { |s| s[:line_of_sight] == true }
        end

        spells.sort_by { |s| s[:level] }
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
          line_of_sight: data['line_of_sight'],
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
