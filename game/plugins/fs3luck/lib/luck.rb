module AresMUSH
  module FS3Luck
    def self.can_manage_luck?(actor)
      actor.has_any_role?(Global.read_config("fs3luck", "roles", "can_manage_luck"))
    end
    
    # Does not save!  Do that yourself!
    def self.modify_luck(char, amount)
      max_luck = Global.read_config("fs3luck", "max_luck")
      char.luck = char.luck + amount
      char.luck = [max_luck, char.luck].min
      char.luck = [0, char.luck].max
    end
  end
end
