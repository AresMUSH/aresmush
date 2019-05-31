module AresMUSH
  class Guild < Ohm::Model
    include ObjectModel
    include FindByName

    attribute :name
    attribute :name_upcase
    attribute :is_public, :type => DataType::Boolean, :default => true
    attribute :members, :type => DataType::Array, :default => []
    attribute :status
    attribute :abbr
    attribute :abbr_upcase
    attribute :ranks, :type => DataType::Hash, :default => {"6 => "Founder", "5" => "Guildmaster", "4" => "Councillor", "3" => "Knight", "2" => "Member", "1" => "Initiate"}

    index :name_upcase

    before_save :save_upcase_guild_name

    def save_upcase_guild_name
      self.name_upcase = self.name.upcase
      self.abbr_upcase = self.abbr.upcase
    end

    index :name
  end
end
