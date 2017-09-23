$:.unshift File.dirname(__FILE__)

load 'web/controllers/admin/admin.rb'
load 'web/controllers/admin/shutdown.rb'
load 'web/controllers/admin/tinker_reset.rb'
load 'web/controllers/admin/tinker_update.rb'
load 'web/controllers/admin/tinker.rb'
load 'web/controllers/admin/logs.rb'

load 'web/controllers/bbs/bbs.rb'
load 'web/controllers/bbs/bbs_post.rb'
load 'web/controllers/bbs/bbs_read_board.rb'
load 'web/controllers/bbs/bbs_read_post.rb'
load 'web/controllers/bbs/bbs_reply.rb'

load 'web/controllers/chars/chars.rb'
load 'web/controllers/chars/edit_char.rb'

load 'web/controllers/chargen/chargen.rb'
load 'web/controllers/chargen/chargen_save.rb'

load 'web/controllers/combat/combat.rb'
load 'web/controllers/combat/combat_add_combatant.rb'
load 'web/controllers/combat/combat_manage_save.rb'
load 'web/controllers/combat/combat_manage.rb'
load 'web/controllers/combat/combat_view.rb'

load 'web/controllers/config/config.rb'
load 'web/controllers/config/config_edit.rb'
load 'web/controllers/config/config_update.rb'
load 'web/controllers/config/config_date.rb'
load 'web/controllers/config/config_secrets.rb'
load 'web/controllers/config/config_skin.rb'
load 'web/controllers/config/config_names.rb'
load 'web/controllers/config/config_fs3combat.rb'
load 'web/controllers/config/config_fs3skills.rb'
load 'web/controllers/config/config_game_info.rb'
load 'web/controllers/config/config_web.rb'
load 'web/controllers/config/config_webfiles.rb'


load 'web/controllers/fs3/fs3.rb'

load 'web/controllers/events/events.rb'

load 'web/controllers/help/help.rb'
load 'web/controllers/help/help_topic.rb'

load 'web/controllers/jobs/job_close.rb'
load 'web/controllers/jobs/job_create.rb'
load 'web/controllers/jobs/job_reply.rb'
load 'web/controllers/jobs/job.rb'
load 'web/controllers/jobs/jobs_index.rb'


load 'web/controllers/locations/locations.rb'

load 'web/controllers/login/login.rb'
load 'web/controllers/login/register.rb'

load 'web/controllers/mail/mail.rb'
load 'web/controllers/mail/mail_reply.rb'
load 'web/controllers/mail/mail_send.rb'

load 'web/controllers/scenes/scene_create.rb'
load 'web/controllers/scenes/scene_edit_participants.rb'
load 'web/controllers/scenes/scene_edit_related.rb'
load 'web/controllers/scenes/scene_edit.rb'
load 'web/controllers/scenes/scenes.rb'

load 'web/controllers/wiki/edit_create_page.rb'
load 'web/controllers/wiki/wiki.rb'

load 'web/controllers/session.rb'
load 'web/controllers/web.rb'
load 'web/controllers/formatters.rb'
load 'web/controllers/files.rb'

load "models/wiki_page.rb"
load "models/wiki_page_version.rb"

load 'wiki_markdown_formatter.rb'
load 'web_cmd_handler.rb'
load 'web_config_updated_handler.rb'
load 'recaptcha_helper.rb'
load 'website_cmd.rb'
load 'filename_sanitizer.rb'

module AresMUSH
  module Website
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      {}
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_website.yml" ]
    end
 
    def self.locale_files
      []
    end
 
    def self.get_cmd_handler(client, cmd, enactor)       
      case cmd.root      
      when "website"
        return WebsiteCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
        when "WebCmdEvent"
          return WebCmdEventHandler
        when "ConfigUpdatedEvent", "GameStartedEvent"
          return WebConfigUpdatedEventHandler
      end
      
      nil
    end
  end
end