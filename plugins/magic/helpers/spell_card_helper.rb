module AresMUSH
  module Magic

    def self.spell_list_config_data(list)
      list.to_a.sort_by { |a| a.level }.map { |a|
        {
          name: a.name,
          level: a.level,
          school: a.school,
          learned: a.learning_complete,
          desc: Website.format_markdown_for_html(Global.read_config("spells", a.name, "desc")),
          potion: Global.read_config("spells", a.name, "potion"),
          weapon: Global.read_config("spells", a.name, "weapon"),
          weapon_specials:  Global.read_config("spells", a.name, "weapon_specials"),
          armor: Global.read_config("spells", a.name, "armor"),
          armor_specials: Global.read_config("spells", a.name, "armor_specials"),
          attack_mod: Global.read_config("spells", a.name, "attack_mod"),
          lethal_mod: Global.read_config("spells", a.name, "lethal_mod"),
          spell_mod:  Global.read_config("spells", a.name, "spell_mod"),
          defense_mod:  Global.read_config("spells", a.name, "defense_mod"),
          duration: Global.read_config("spells", a.name, "duration"),
          casting_time: Global.read_config("spells", a.name, "casting_time"),
          range: Global.read_config("spells", a.name, "range"),
          area: Global.read_config("spells", a.name, "area"),
          targets: Global.read_config("spells", a.name, "targets"),
          heal: Global.read_config("spells", a.name, "heal_points"),
          effect: Global.read_config("spells", a.name, "effect"),
          damage_type:  Global.read_config("spells", a.name, "damage_type"),
          available: Global.read_config("spells", a.name, "available"),
          los:  Global.read_config("spells", a.name, "line_of_sight")
          }}
    end

    def self.spell_list_all_data(list)
      spells = Magic.spell_list_config_data(list)
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
    end

    def self.major_school_spells(char, spell_list)
      major_school = char.group("Major School")
      major_spells = []
      spell_list.each do |s|
        if (s[:school] == major_school)
          major_spells.concat [s]
        end
      end
      return major_spells
    end

    def self.minor_school_spells(char, spell_list)
      minor_school = char.group("Minor School")
      if minor_school != "None"
        minor_spells = []
        spell_list.each do |s|
          if (s[:school] == minor_school)
            minor_spells.concat [s]
          end
        end
      else
        minor_spells = nil
      end
      return minor_spells
    end

    def self.other_spells(char, spell_list)
      minor_school = char.group("Minor School")
      major_school = char.group("Major School")
      other_spells = []
      spell_list.each do |s|
        if (s[:school] != minor_school && s[:school] != major_school)
          other_spells.concat [s]
        end
      end
      return other_spells
    end

  end
end
