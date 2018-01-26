$:.unshift File.dirname(__FILE__)


module AresMUSH
  module Channels
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("channels", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)      
      case cmd.root
      when "channel"
        case cmd.switch
        when "alias"
          return ChannelAliasCmd 
        when "announce"
          return ChannelAnnounceCmd
        when "color"
          return ChannelColorCmd
        when "create"
          return ChannelCreateCmd
        when "defaultalias"
          return ChannelDefaultAlias
        when "delete"
          return ChannelDeleteCmd
        when "desc"
          return ChannelDescCmd
        when "mute", "unmute"
          return ChannelMuteCmd
        when "join"
          return ChannelJoinCmd
        when "leave"
          return ChannelLeaveCmd
        when "list", nil
          return ChannelListCmd
        when "recall"
          return ChannelRecallCmd
        when "rename"
          return ChannelRenameCmd
        when "report"
          return ChannelReportCmd
        when "roles"
          return ChannelRolesCmd
        when "title"
          return ChannelTitleCmd
        when "who"
          return ChannelWhoCmd
        end
      else
        if (is_talk_cmd(enactor, cmd))
          return ChannelTalkCmd
        end
      end
      return nil   
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CharCreatedEvent"
        return CharCreatedEventHandler
      when "CharConnectedEvent"
        return CharConnectedEventHandler
      when "CharDisconnectedEvent"
        return CharDisconnectedEventHandler
      when "RoleChangedEvent"
        return RoleChangedEventHandler
      when "RoleDeletedEvent"
        return RoleDeletedEventHandler
      end
      nil
    end
  end
end
