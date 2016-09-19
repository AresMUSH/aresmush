$:.unshift File.dirname(__FILE__)
load "lib/compose/mail_append_cmd.rb"
load "lib/compose/mail_proof_cmd.rb"
load "lib/compose/mail_send_comp_cmd.rb"
load "lib/compose/mail_start_cmd.rb"
load "lib/compose/mail_toss_cmd.rb"
load "lib/helpers.rb"
load "lib/mail_events.rb"
load "lib/mail_fwd_cmd.rb"
load "lib/mail_inbox_cmd.rb"
load "lib/mail_model.rb"
load "lib/mail_new_cmd.rb"
load "lib/mail_read_cmd.rb"
load "lib/mail_reply_cmd.rb"
load "lib/mail_review_cmd.rb"
load "lib/mail_send_cmd.rb"
load "lib/mail_sentmail_cmd.rb"
load "lib/mail_unsend_cmd.rb"
load "lib/manage/mail_archive_cmd.rb"
load "lib/manage/mail_backup_cmd.rb"
load "lib/manage/mail_delete_cmd.rb"
load "lib/manage/mail_empty_trash_cmd.rb"
load "lib/manage/mail_filter_cmd.rb"
load "lib/manage/mail_tag_cmd.rb"
load "lib/manage/mail_tags_cmd.rb"
load "lib/manage/mail_undelete_cmd.rb"
load "mail_interfaces.rb"
load "templates/forwarded_template.rb"
load "templates/inbox_template.rb"
load "templates/message_template.rb"

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
 
    def self.help_files
      [ "help/mail.md", "help/mail_composition.md", "help/mail_managing.md", "help/mail_review.md", "help/mail_sending.md", "help/mail_tags.md" ]
    end
 
    def self.config_files
      [ "config_mail.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       false
    end

    def self.handle_event(event)
    end
  end
end