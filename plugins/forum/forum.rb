$:.unshift File.dirname(__FILE__)


module AresMUSH
  module Forum
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("forum", "shortcuts")
    end
 
    def self.achievements
      Global.read_config('forum', 'achievements')
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
      when "editreply"
        return ForumEditReplyCmd
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
      when "hide", "show", "unhide"
        return ForumHideCmd      
      when "move"
        return ForumMoveCmd
      when "mute", "unmute"
        return ForumMuteCmd
      when "new"
        return ForumNewCmd
      when "order"
        return ForumOrderCmd
      when "pin"
        return ForumPinCmd
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
      when "CharDisconnectedEvent"
        return CharDisconnectedEventHandler
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
      when "forumCatchup"
        return ForumCatchupRequestHandler
      when "forumEditReply"
        return ForumEditReplyRequestHandler
      when "forumEditTopic"
        return ForumEditTopicRequestHandler
      when "forumDeleteReply"
        return ForumDeleteReplyRequestHandler
      when "forumDeleteTopic"
        return ForumDeleteTopicRequestHandler
      when "forumHide"
        return ForumHideRequestHandler
      when "forumList"
        return ForumListRequestHandler
      when "forumMove"
        return ForumMoveTopicRequestHandler
      when "forumMute"
        return ForumMuteRequestHandler
      when "forumPin"
        return ForumPinRequestHandler
      when "forumTopic"
        return ForumTopicRequestHandler
      when "forumUnread"
        return ForumUnreadRequestHandler
      when "forumRecent"
        return RecentForumPostsRequestHandler
      when "createForum"
        return CreateForumRequestHandler
      when "deleteForum"
        return DeleteForumRequestHandler
      when "editForum"
        return EditForumRequestHandler
      when "manageForum"
        return ManageForumRequestHandler
      when "saveForum"
        return SaveForumRequestHandler
      when "searchForum"
        return SearchForumRequestHandler
      end
    end
    
  end
end
