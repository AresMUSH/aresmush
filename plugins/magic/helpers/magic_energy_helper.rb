module AresMUSH
  module Magic

    def self.subtract_magic_energy(char_or_npc, spell, success)
      char = char_or_npc
      puts "Magic energy before subtraction: #{char.name} #{char.magic_energy}"
      level = Global.read_config("spells", spell, "level")
      spell_school = Global.read_config("spells", spell, "school")
      cost = Global.read_config("magic", "energy_cost_by_level", level)
      puts "Level: #{level} Starting Cost: #{cost}"
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
      success == "%xrFAILS%xn" ? cost = cost/2 : cost = cost
      magic_energy = [(char.magic_energy - cost), 0].max
      char.update(magic_energy: magic_energy)
      puts "Cost: #{cost} Magic energy after subtraction: #{char.name} #{char.magic_energy}"
    end

    def self.get_fatigue_level(char_or_npc)
      char = char_or_npc
      if (char.magic_energy <= char.total_magic_energy*0.8) && (char.magic_energy >= char.total_magic_energy*0.6)
        degree = "Mild"
        color = "%xg"
        effect = Global.read_config("magic", "fatigue_effect", "Mild")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "MILD%xn", :effect => effect)
      elsif (char.magic_energy <= char.total_magic_energy*0.6) && (char.magic_energy >= char.total_magic_energy*0.4)
        degree = "Moderate"
        color = "%xc"
        effect = Global.read_config("magic", "fatigue_effect", "Moderate")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "MODERATE%xn", :effect => effect)
      elsif (char.magic_energy <= char.total_magic_energy*0.4) && (char.magic_energy >= char.total_magic_energy*0.2)
        degree = "Severe"
        color = "%xy"
        effect = Global.read_config("magic", "fatigue_effect", "Severe")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "SEVERE%xn", :effect => effect)
      elsif (char.magic_energy <= char.total_magic_energy*0.2) && (char.magic_energy >= char.total_magic_energy*0.1)
        degree = "Extreme"
        color = "%xm"
        effect = Global.read_config("magic", "fatigue_effect", "Extreme")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "EXTREME%xn", :effect => effect)
      elsif (char.magic_energy <= char.total_magic_energy*0.10)
        degree = "Total"
        color = "%xr"
        effect = Global.read_config("magic", "fatigue_effect", "Total")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "TOTAL%xn", :effect => effect)
      else
        degree = "None"
        color = ""
        effect = Global.read_config("magic", "fatigue_effect", "None")
        msg = t('magic.magic_fatigue', :name => char.name, :color => color, :degree => "no%xn", :effect => effect)
      end
      puts "COLOR: #{color}"
      return {
        msg: msg,
        degree: degree,
        color: color
      }
    end

    def self.get_magic_energy_mod(char_or_npc)
      degree = Magic.get_fatigue_level(char_or_npc)[:degree]
      if degree == "Mild"
        mod = -1
      elsif degree == "Moderate"
        mod = -2
      elsif degree == "Severe"
        mod = -3
      elsif degree == "Extreme"
        mod = -4
      elsif degree == "Total"
        mod = -100
      else
        mod = 0
      end
      return mod
    end

    def self.magic_energy_cron(char)
      puts "Magic energy before cron: #{char.name} #{char.magic_energy} Rate #{char.magic_energy_rate}"
      new_magic_energy =  char.magic_energy + char.magic_energy_rate
      puts "New energy #{new_magic_energy}"
      if new_magic_energy < char.total_magic_energy
        char.update(magic_energy: new_magic_energy )
      else
        char.update(magic_energy: char.total_magic_energy)
      end
      puts "Magic energy after: #{char.magic_energy}"
    end

  end
end
