module AresMUSH
  module FS3Luck
    def self.can_manage_luck?(actor)
      actor.has_any_role?(Global.config['fs3luck']['roles']['can_manage_luck'])
    end
  end
end
