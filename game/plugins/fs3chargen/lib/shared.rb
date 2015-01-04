module AresMUSH
  module Chargen
    def self.can_approve?(actor)
      actor.has_any_role?(Global.config['chargen']['roles']['can_approve'])
    end
  end
end
