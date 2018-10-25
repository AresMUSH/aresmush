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
        when "addchar"
          return ChannelForceJoinCmd
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
        when "removechar"
          return ChannelForceLeaveCmd
        when "rename"
          return ChannelRenameCmd
        when "report"
          return ChannelReportCmd
        when "roles"
          return ChannelRolesCmd
        when "title"
          return ChannelTitleCmd
        when "showtitles"
          return ChannelShowTitlesCmd
        when "who"
          return ChannelWhoCmd
        end
      else
        if (cmd.root_is?("chat") && !cmd.args)
          return ChannelListCmd
        end
        
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
      when "CronEvent"
        return CronEventHandler
      when "CharApprovedEvent"
        return CharApprovedEventHandler
      end
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "chat"
        return ChatRequestHandler
      when "chatTalk"
        return ChatTalkRequestHandler
      when "joinChannel"
        return JoinChannelRequestHandler
      when "leaveChannel"
        return LeaveChannelRequestHandler
      when "muteChannel"
        return MuteChannelRequestHandler
      end
    end
    
  end
end
