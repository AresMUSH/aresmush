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
        when "clear"
          return ChannelClearCmd
        when "color"
          return ChannelColorCmd
        when "create"
          return ChannelCreateCmd
        when "defaultcolor"
          return ChannelDefaultColorCmd
        when "defaultalias"
          return ChannelDefaultAlias
        when "delete"
          return ChannelDeleteCmd
        when "desc"
          return ChannelDescCmd
        when "info"
          return ChannelInfoCmd
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
        when "joinroles", "talkroles"
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
        
        if (Channels.is_talk_cmd(enactor, cmd))
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
      when "createChannel"
        return CreateChannelRequestHandler
      when "deleteChannel"
        return DeleteChannelRequestHandler
      when "editChannel"
        return EditChannelRequestHandler
      when "joinChannel"
        return JoinChannelRequestHandler
      when "leaveChannel"
        return LeaveChannelRequestHandler
      when "manageChat"
        return ManageChatRequestHandler
      when "muteChannel"
        return MuteChannelRequestHandler
      when "reportChat"
        return ReportChatRequestHandler
      when "saveChannel"
        return SaveChannelRequestHandler
      end
    end

    def self.check_config
      validator = ChannelConfigValidator.new
      validator.validate
    end
  end
end
