$:.unshift File.dirname(__FILE__)
load "lib/channel_alias_cmd.rb"
load "lib/channel_announce_cmd.rb"
load "lib/channel_mute_cmd.rb"
load "lib/channel_join_cmd.rb"
load "lib/channel_leave_cmd.rb"
load "lib/channel_list_cmd.rb"
load "lib/channel_model.rb"
load "lib/channel_recall_cmd.rb"
load "lib/channel_talk_cmd.rb"
load "lib/channel_title_cmd.rb"
load "lib/channel_who_cmd.rb"
load "lib/event_handling.rb"
load "lib/helpers.rb"
load "lib/management/channel_attribute_cmd.rb"
load "lib/management/channel_create_cmd.rb"
load "lib/management/channel_delete_cmd.rb"
load "templates/channel_list_template.rb"
load "channel_api.rb"

module AresMUSH
  module Channels
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("channels", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_channels.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
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
      when "RolesChangedEvent"
        return RolesChangedEventHandler
      when "RolesDeletedEvent"
        return RolesDeletedEventHandler
      end
      nil
    end
  end
end