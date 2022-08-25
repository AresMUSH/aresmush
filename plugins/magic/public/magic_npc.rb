module AresMUSH
  class Npc

    collection :magic_shields, "AresMUSH::MagicShields"
    attribute :magic_energy, :type => DataType::Integer, :default => 100
    attribute :magic_item_equipped, :default => "None"

    attribute :dead, :type => DataType::Boolean, :default => false

    before_delete :clear_shields

    def clear_shields
      self.magic_shields.each { |s| s.delete }
    end

    def total_magic_energy
      magic = self.ability_rating("Magic")
      stats = FS3Combat.npc_type(self.level)
      default = stats["Default"] || 4
      return (magic + default) * 10
    end



  end
end
