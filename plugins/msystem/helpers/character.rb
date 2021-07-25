module AresMUSH
  module Msystem
    def self.get_skill_base(char, name)
      skill = get_skill(name)
      skill["base"].reduce(0) do |base, n|
        if n.is_a? Integer
          base + n
        else
          base + char.characteristics.find(name: n).first.rating
        end
      end
    end

    def self.recalc_skill_bases(char)
      char.skills.each{ |s| s.update(base: get_skill_base(char, s.name)) }
    end

    def self.set_abilities(char)
      settings = Global.read_config("mspace", "system")
      char.update(
        action_points: settings["action_points"],
        damage_mod: get_damage_mod(get_stat_total(char, settings["damage_mod"])),
        heal_rate: get_stepped_value(get_stat_total(char, settings["heal_rate"])),
        luck_points: get_stepped_value(get_stat_total(char, settings["luck_points"])),
        power_points: get_stat_total(char, settings["power_points"]),
        hit_points: get_average_value(
          get_stat_total(char, settings["hit_points"]),
          settings["hit_points"].size
        ),
        initiative: get_average_value(
          get_stat_total(char, settings["initiative"]),
          settings["initiative"].size
        ),
        movement_rate: Global.read_config("mspace", "species", char.species)["movement_rate"]
      )
      set_hit_locs(char, get_stat_total(char, settings["hit_points"]))
    end


    def self.set_hit_locs(char, total)
      species = Global.read_config("mspace", "species", char.species)
      hitloc_hp = Hash.new
      species["locations"].each{ |k, v| 
        hitloc_hp[k] = [1, ((total - 1) / 5) + v].max
      }
      char.update(hitloc_hp: hitloc_hp)
    end

    def self.get_stat_total(char, list)
      list.map{ |s| 
        stat = get_stat(char, s)
        stat.nil? ? 0 : stat.rating
      }.reduce(:+)
    end

    def self.get_stat(char, stat)
      name = stat ? stat.titlecase : nil
      type = get_stat_type(name)

      case type
      when :characteristic
        char.characteristics.find(name: name).first
      when :skill
        char.skills.find(name: name).first
      else
        nil
      end
    end

    def self.set_stat(char, stat, value)
      name = stat ? stat.titlecase : nil
      stat = get_stat(char, name)
      type = get_stat_type(name)

      case type
      when :characteristic
        if stat
          stat.update(rating: value)
        else
          MCharacteristic.create(character: char, name: name, rating: value)
        end
        recalc_skill_bases(char)
        set_abilities(char)
      when :skill
        return stat.update(rating: value) if stat
        skill = get_skill(name)
        MSkill.create(
          character: char, 
          name: name, 
          rating: value, 
          type: skill["type"], 
          base: get_skill_base(char, skill["name"])
        )
      end
      return nil
    end

    def self.init_char(char)
      char.characteristics.each{ |c| c.delete }
      char.skills.each{ |s| s.delete }
      char.update(species: Global.read_config("mspace", "species", "default"))
      
      get_stat_names("characteristics").each do |c|
        set_stat(char, c, 0)
      end

      get_stat_names("skills").each do |s|
        set_stat(char, s, 0)
      end
    end
  end
end