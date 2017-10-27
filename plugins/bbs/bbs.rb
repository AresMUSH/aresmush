$:.unshift File.dirname(__FILE__)
load "engine/bbs_archive_cmd.rb"
load "engine/bbs_board_cmd.rb"
load "engine/bbs_catchup_cmd.rb"
load "engine/bbs_delete_cmd.rb"
load "engine/bbs_edit_cmd.rb"
load "engine/bbs_list_cmd.rb"
load "engine/bbs_move_cmd.rb"
load "engine/bbs_new_cmd.rb"
load "engine/bbs_post_cmd.rb"
load "engine/bbs_read_cmd.rb"
load "engine/bbs_reply_cmd.rb"
load "engine/bbs_delete_reply_cmd.rb"
load "engine/bbs_scan_cmd.rb"
load "engine/role_deleted_event_handler.rb"
load "engine/management/bbs_attribute_cmd.rb"
load "engine/management/bbs_create_board_cmd.rb"
load "engine/management/bbs_delete_board_cmd.rb"
load "engine/management/bbs_delete_confirm_cmd.rb"
load "engine/templates/archive_template.rb"
load "engine/templates/board_list_template.rb"
load "engine/templates/board_template.rb"
load "engine/templates/post_template.rb"
load "lib/bbs_api.rb"
load "lib/helpers.rb"
load "lib/bbs_board.rb"
load "lib/bbs_reply.rb"
load "lib/bbs_post.rb"
load 'web/controllers/bbs.rb'
load 'web/controllers/bbs_post.rb'
load 'web/controllers/bbs_reply.rb'


module AresMUSH
  module Bbs
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("bbs", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_bbs.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      return nil if !cmd.root_is?("bbs")
      
      case cmd.switch
      when "archive"
        return BbsArchive 
      when "catchup"
        return BbsCatchupCmd
      when "confirmdelete"
        return BbsDeleteBoardConfirmCmd
      when "createboard"
        return BbsCreateBoardCmd
      when "delete"
        return BbsDeleteCmd
      when "deletereply"
        return BbsDeleteReplyCmd
      when "deleteboard"
        return BbsDeleteBoardCmd
      when "describe"
        return BbsDescCmd
      when "edit"
        return BbsEditCmd        
      when "move"
        return BbsMoveCmd
      when "new"
        return BbsNewCmd
      when "order"
        return BbsOrderCmd
      when "post"
        return BbsPostCmd
      when "readroles", "writeroles"
        return BbsRolesCmd
      when "rename"
        return BbsRenameCmd
      when "reply"
        return BbsReplyCmd
      when "scan"
        return BbsScanCmd
      when nil
        if (!cmd.args)
          return BbsListCmd 
        elsif (cmd.args =~ /[\/]/)
          return BbsReadCmd 
        else
          return BbsBoardCmd           
        end
      end
      
      return nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "RoleDeletedEvent"
        return RoleDeletedEventHandler
      end
      
      nil
    end
  end
end