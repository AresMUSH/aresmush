module AresMUSH
  module Guilds
    def self.all_guilds
       Global.read_config("guilds", "master_list") || {}
    end
    def self.is_member?(c,g)
      true
    end # def is_member?
  end
end
