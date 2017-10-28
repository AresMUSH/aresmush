$:.unshift File.dirname(__FILE__)
load "engine/compose/mail_append_cmd.rb"
load "engine/compose/mail_proof_cmd.rb"
load "engine/compose/mail_send_comp_cmd.rb"
load "engine/compose/mail_start_cmd.rb"
load "engine/compose/mail_toss_cmd.rb"
load "engine/char_disconnected_event_handler.rb"
load "engine/mail_fwd_cmd.rb"
load "engine/mail_inbox_cmd.rb"
load "engine/mail_job_cmd.rb"
load "engine/mail_new_cmd.rb"
load "engine/mail_read_cmd.rb"
load "engine/mail_reply_cmd.rb"
load "engine/mail_review_cmd.rb"
load "engine/mail_send_cmd.rb"
load "engine/mail_sentmail_cmd.rb"
load "engine/mail_unsend_cmd.rb"
load "engine/manage/mail_archive_cmd.rb"
load "engine/manage/mail_backup_cmd.rb"
load "engine/manage/mail_delete_cmd.rb"
load "engine/manage/mail_empty_trash_cmd.rb"
load "engine/manage/mail_filter_cmd.rb"
load "engine/manage/mail_tag_cmd.rb"
load "engine/manage/mail_tags_cmd.rb"
load "engine/manage/mail_undelete_cmd.rb"
load "engine/templates/forwarded_template.rb"
load "engine/templates/inbox_template.rb"
load "engine/templates/message_template.rb"
load "lib/helpers.rb"
load "lib/mail_model.rb"
load "lib/mail_api.rb"
load 'web/mail.rb'
load 'web/mail_reply.rb'
load 'web/mail_send.rb'

module AresMUSH
  module Mail
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("mail", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_mail.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
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
  end
end