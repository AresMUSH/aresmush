module AresMUSH
  module Magic

    def self.reset_magic_energy(char)
      Global.logger.debug "Magic energy before reset: #{char.name}: #{char.magic_energy}"
      char.update(magic_energy: char.total_magic_energy)
      Global.logger.debug  "Magic energy after reset: #{char.name}: #{char.magic_energy}"
    end

    def self.set_npc_energy(npc, percent)
      new_energy = npc.total_magic_energy * percent
      npc.update(magic_energy: new_energy)
    end

    def self.subtract_magic_energy(char_or_npc, spell, success)
      char = char_or_npc
      Global.logger.debug  "Magic energy before subtraction: #{char.name} #{char.magic_energy}"
      level = Global.read_config("spells", spell, "level")
      spell_school = Global.read_config("spells", spell, "school")
      cost = Global.read_config("magic", "energy_cost_by_level", level)
      Global.logger.debug  "Level: #{level} Starting Cost: #{cost}"
      if (char.class == Npc)
        cost = cost + 1
      else
        if char.major_schools.include?(spell_school)
          cost = cost
        elsif char.minor_schools.include?(spell_school)
          cost = cost + 2
        else
          cost = cost + 3
        end
      end
      success == "%xrFAILS%xn" ? cost = cost/4 : cost = cost
      magic_energy = [(char.magic_energy - cost), 0].max
      char.update(magic_energy: magic_energy)
      Global.logger.debug  "Cost: #{cost} Magic energy after subtraction: #{char.name} #{char.magic_energy}"
    end

    def self.get_fatigue_level(char_or_npc)
      char = char_or_npc
      if (char.magic_energy <= char.total_magic_energy*0.8) && (char.magic_energy >= char.total_magic_energy*0.66)
        degree = "Mild"
        color = "%X2"
        effect = Global.read_config("magic", "fatigue_effect", "Mild")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "MILD%xn", :effect => effect)
      elsif (char.magic_energy <= char.total_magic_energy*0.65) && (char.magic_energy >= char.total_magic_energy*0.51)
        degree = "Moderate"
        color = "%X6"
        effect = Global.read_config("magic", "fatigue_effect", "Moderate")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "MODERATE%xn", :effect => effect)
      elsif (char.magic_energy <= char.total_magic_energy*0.5) && (char.magic_energy >= char.total_magic_energy*0.36)
        degree = "Severe"
        color = "%X57"
        effect = Global.read_config("magic", "fatigue_effect", "Severe")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "SEVERE%xn", :effect => effect)
      elsif (char.magic_energy <= char.total_magic_energy*0.35) && (char.magic_energy >= char.total_magic_energy*0.16)
        degree = "Extreme"
        color = "%xR"
        effect = Global.read_config("magic", "fatigue_effect", "Extreme")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "EXTREME%xn", :effect => effect)
      elsif (char.magic_energy <= char.total_magic_energy*0.15)
        degree = "Total"
        color = "%X1"
        effect = Global.read_config("magic", "fatigue_effect", "Total")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "TOTAL%xn", :effect => effect)
      else
        degree = "None"
        color = ""
        effect = Global.read_config("magic", "fatigue_effect", "None")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "no%xn", :effect => effect)
      end
      Global.logger.debug "Magic energy fatigue level: #{msg}, #{degree}"
      return {
        msg: msg,
        degree: degree,
        color: color
      }
    end

    def self.get_magic_energy_mod(char_or_npc)
      degree = Magic.get_fatigue_level(char_or_npc)[:degree]
      if degree == "Mild"
        mod = Global.read_config("magic", "fatigue_mod", "Mild")
      elsif degree == "Moderate"
        mod = Global.read_config("magic", "fatigue_mod", "Moderate")
      elsif degree == "Severe"
        mod = Global.read_config("magic", "fatigue_mod", "Severe")
      elsif degree == "Extreme"
        mod = Global.read_config("magic", "fatigue_mod", "Extreme")
      elsif degree == "Total"
        mod = Global.read_config("magic", "fatigue_mod", "Total")
      else
        mod = 0
      end
      return mod
    end

    def self.magic_energy_cron(char)
      Global.logger.debug  "Magic energy before cron: #{char.name} #{char.magic_energy} Rate #{char.magic_energy_rate}"
      new_magic_energy =  char.magic_energy + char.magic_energy_rate
      Global.logger.debug  "New energy #{new_magic_energy}"
      if new_magic_energy < char.total_magic_energy
        char.update(magic_energy: new_magic_energy )
      else
        char.update(magic_energy: char.total_magic_energy)
      end
      Global.logger.debug  "Magic energy after: #{char.magic_energy}"
    end

  end
end
