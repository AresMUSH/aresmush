module AresMUSH
  class Npc

    collection :magic_shields, "AresMUSH::MagicShields"
    attribute :magic_item_equipped, :default => "None"

    before_delete :clear_shields

    def clear_shields
      self.magic_shields.each { |s| s.delete }
    end


  end
end
