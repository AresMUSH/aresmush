$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Guilds

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("guilds", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "guilds"
        return GuildsCmd
      when "guild"
        case cmd.switch
        when "add"
          return GuildAddCmd
        when "rem"
          return GuildRemCmd
        when "promote"
          return GuildPromoteCmd
        when "demote"
          return GuildDemoteCmd
        when "ranktitle"
          return GuildRankTitleCmd
        else
          return GuildsCmd
        end
      else
        nil
      end
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
