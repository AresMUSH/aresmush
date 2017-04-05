module AresMUSH
  module FS3Skills
    def self.can_manage_luck?(actor)
      actor.has_permission?("manage_luck")
    end
    
    def self.modify_luck(char, amount)
      max_luck = Global.read_config("fs3skills", "max_luck")
      luck = char.luck + amount
      luck = [max_luck, luck].min
      luck = [0, luck].max
      char.update(fs3_luck: luck)
    end
  end
end
