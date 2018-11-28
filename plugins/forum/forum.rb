$:.unshift File.dirname(__FILE__)


module AresMUSH
  module Forum
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("forum", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      return nil if !cmd.root_is?("forum")
      
      case cmd.switch
      when "archive"
        return ForumArchive 
      when "catchup"
        return ForumCatchupCmd
      when "confirmdelete"
        return ForumDeleteCategoryConfirmCmd
      when "createcat"
        return ForumCreateCategoryCmd
      when "delete"
        return ForumDeleteCmd
      when "deletereply"
        return ForumDeleteReplyCmd
      when "deletecat"
        return ForumDeleteCategoryCmd
      when "describe"
        return ForumDescCmd
      when "edit"
        return ForumEditCmd        
      when "move"
        return ForumMoveCmd
      when "new"
        return ForumNewCmd
      when "order"
        return ForumOrderCmd
      when "post"
        return ForumPostCmd
      when "readroles", "writeroles"
        return ForumRolesCmd
      when "rename"
        return ForumRenameCmd
      when "reply"
        return ForumReplyCmd
      when "scan"
        return ForumScanCmd
      when nil
        if (!cmd.args)
          return ForumIndexCmd 
        elsif (cmd.args =~ /[\/]/)
          return ForumReadCmd 
        else
          return ForumCategoryCmd           
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
      when "forumUnread"
        return ForumUnreadRequestHandler
      when "forumRecent"
        return RecentForumPostsRequestHandler
      when "searchForum"
        return SearchForumRequestHandler
      end
    end
    
  end
end
