$:.unshift File.dirname(__FILE__)


module AresMUSH
  module Bbs
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("bbs", "shortcuts")
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
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "forumPost"
        return AddPostRequestHandler
      when "forumReply"
        return AddReplyRequestHandler
      when "forumCategory"
        return ForumCategoryRequestHandler
      when "forumList"
        return ForumListRequestHandler
      when "forumTopic"
        return ForumTopicRequestHandler
      end
    end
    
  end
end
