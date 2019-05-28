module AresMUSH
  class Character
    collection :guilds, "AresMUSH::GuildObj"

    before_delete :delete_guilds
    def delete_guilds
     self.guilds.each do |list|
      list.each do |a|
        a.delete
      end
     end
    end # def delete_guilds
    def guildlist
      self.guilds.sort_by(:name, :order => "ALPHA").map { |g| g.name }
    end # def guild
    def guildrank(name,guild)

    end # def guildrank
  end # Class Character
end # Module AresMUSH
