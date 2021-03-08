module AresMUSH
  class Npc

    collection :magic_shields, "AresMUSH::MagicShields"

    before_delete :clear_shields

    def clear_shields
      self.magic_shields.each { |s| s.delete }
    end


  end
end
