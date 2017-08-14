$:.unshift File.dirname(__FILE__)
load "lib/channel_alias_cmd.rb"
load "lib/channel_announce_cmd.rb"
load "lib/channel_mute_cmd.rb"
load "lib/channel_join_cmd.rb"
load "lib/channel_leave_cmd.rb"
load "lib/channel_list_cmd.rb"
load "lib/channel_recall_cmd.rb"
load "lib/channel_talk_cmd.rb"
load "lib/channel_title_cmd.rb"
load "lib/channel_who_cmd.rb"
load "lib/char_connected_event_handler.rb"
load "lib/char_disconnected_event_handler.rb"
load "lib/char_created_event_handler.rb"
load "lib/role_changed_event_handler.rb"
load "lib/role_deleted_event_handler.rb"
load "lib/helpers.rb"
load "lib/management/channel_attribute_cmd.rb"
load "lib/management/channel_create_cmd.rb"
load "lib/management/channel_delete_cmd.rb"
load "public/channel_api.rb"
load "public/channel.rb"
load "public/channel_options.rb"
load "public/channel_char.rb"
load "templates/channel_list_template.rb"

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
        when "talk"
          return ChannelTalkCmd
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