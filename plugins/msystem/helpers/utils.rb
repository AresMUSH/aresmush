module AresMUSH
  module Msystem
    def self.can_manage_abilities?(actor)
      actor.has_permission?("manage_abilities")
    end

    def self.can_view_sheets?(actor)
      return true if Global.read_config("mspace", "public_sheets")
      return false if !actor
      actor.has_permission?("view_sheets")
    end

    def self.is_staff?(actor)
      return false if !actor
      actor.has_role?("staff") || actor.is_admin?
    end

    def self.characteristics
      Global.read_config("mspace", "characteristics")
    end

    def self.skills
      Global.read_config("mspace", "skills")
    end

    def self.cultures
      Global.read_config("mspace", "cultures")
    end

    def self.careers
      Global.read_config("mspace", "careers")
    end

    def self.get_stat_names(stat)
      Global.read_config("mspace", stat).map { |s| s["name"].titlecase }
    end

    def self.get_skill(skill)
      skills.select{ |s| s["name"] == skill.titlecase }.first
    end

    def self.check_stat_name(stat)
      return t("mspace.no_special_characters") if (stat !~ /^[\w\s]+$/)
    end

    def self.get_stat_type(stat)
      stat = stat.titlecase

      if (get_stat_names("skills").include? stat)
        return :skill
      elsif (get_stat_names("characteristics").include? stat)
        return :characteristic
      end
    end

    def self.get_damage_mod(total)
      steps = [
        "-1d8", "-1d6", "-1d4", "-1d2", "+0", "+1d2", "+1d4", "+1d6", "+1d8",
        "+1d10", "+1d12", "+2d6", "+1d8+1d6", "+2d8", "+1d10+1d8",
        "+2d10", "+2d10+1d2", "+2d10+1d4", "+2d10+1d6", "+2d10+1d8",
        "+3d10", "+3d10+1d2", "+3d10+1d4", "+3d10+1d6", "+3d10+1d8",
        "+4d10", "+4d10+1d2", "+4d10+1d4", "+4d10+1d6", "+4d10+1d8",
        "+5d10", "+5d10+1d2", "+5d10+1d4", "+5d10+1d6", "+5d10+1d8"
      ]
      return steps[0] if total < 5
      return steps[(total / 5).to_i] if total <= 50
      return steps[4 + (total / 10).to_i] if total < 310
      return steps[-1]
    end

    def self.get_stepped_value(total, step = 6)
      return ((total - 1) / step) + 1
    end

    def self.get_average_value(total, size)
      return (total.to_f / size).ceil
    end
  end
end