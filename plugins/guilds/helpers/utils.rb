module AresMUSH
  module Guilds
    def self.all_guilds
       Global.read_config("guilds", "guilds_list") || {}
    end
  end
end
