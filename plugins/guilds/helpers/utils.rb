module AresMUSH
  module Guilds
    def self.all_guilds
       Global.read_config("guilds", "master_list") || {}
    end
    def self.is_member?(c,g)
      guild = c.guilds.find(name: g).first
      if (!guild)
        false
      else
        true
      end
    end # def is_member?
    def self.add_member(guild_name,character)
      guild = Guild.find_one_by_name(guild_name)
      members = guild.members.push(ccharacter)
      guild.update(members: members)
      GuildMember.create(character: character,name: guild_name,rank: 1,title: "Member")
    end # def add_member
  end
end
