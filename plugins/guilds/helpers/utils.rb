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
    def self.add_member(g,c)
      guild = Guild.find_one_by_name(g).first
      members = guild.members.push(c)
      guild.update(members: members)
      GuildMember.create(character: c,name: g,rank: 1,title: "Member")      
    end # def add_member
  end
end
