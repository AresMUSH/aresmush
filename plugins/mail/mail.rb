$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Mail
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("mail", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "mail"
        case cmd.switch
        when "job"
          return MailJobCmd
        when "proof"
          return MailProofCmd
        when "send"
          return MailSendComposition
        when "start"
          return MailStartCmd
        when "toss"
          return MailTossCmd
        when "backup"
          return MailBackupCmd
        when "delete"
          return MailDeleteCmd
        when "tag", "untag"
          return MailTagCmd
        when "tags"
          return MailTagsCmd
        when "emptytrash"
          return MailEmptyTrashCmd
        when "filter", "inbox", "sent", "trash"
          return MailFilterCmd
        when "archive"
          if (cmd.args)
            return MailArchiveCmd
          else
            return MailFilterCmd
          end
        when "fwd"         
          return MailFwdCmd
        when "new"
          return MailNewCmd
        when "reply", "replyall"
          return MailReplyCmd
        when "review"
          return MailReviewCmd
        when "sentmail"
          return MailSentMailCmd
        when "unsend"
          return MailUnsendCmd
        when "undelete"
          return MailUndeleteCmd
        when nil
          if (cmd.args)
            if (cmd.args =~ /[\=]/ && cmd.args !~ /[\/]/)
              return MailStartCmd
            elsif (cmd.args =~ /.*\=.*\/.*/)
              return MailSendCmd
            else
              return MailReadCmd
            end
          else
            return MailInboxCmd
          end
        end
      when "--"
        return MailSendComposition         
      end
       
      if (cmd.root.starts_with?("-"))
        return MailAppendCmd
      end
       
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CharDisconnectedEvent"
        return CharDisconnectedEventHandler
      end
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "mailIndex"
        return MailIndexRequestHandler
      when "mailMessage"
        return MailMessageRequestHandler
      when "sendMail"
        return MailSendRequestHandler
      when "archiveMail"
        return MailArchiveRequestHandler
      when "deleteMail"
        return MailDeleteRequestHandler
      when "undeleteMail"
        return MailUndeleteRequestHandler
      when "tagMail"
        return MailTagsRequestHandler
      end
      nil
    end
  end
end
