module AresMUSH
  module FS3Skills
    def self.can_manage_xp?(actor)
      actor.has_any_role?(Global.read_config("fs3skills", "roles", "can_manage_xp"))
    end
    
    def self.modify_xp(char, amount)
      max_xp = Global.read_config("fs3skills", "max_xp_hoard")
      xp = char.xp + amount
      xp = [max_xp, xp].min
      char.update(fs3_xp: xp)
    end
  end
end