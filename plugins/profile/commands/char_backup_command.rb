module AresMUSH

  module Profile
    class CharBackupCmd
      include CommandHandler
      
      attr_accessor :target
      
      def parse_args
        self.target = !cmd.args ? enactor.name : titlecase_arg(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          
          if (enactor.is_admin?)
            self.export_wiki(model)
          else
            self.export_game(model)
          end          
          
        end
      end
      
      def export_game(model)
        commands = Global.read_config("profile", "backup_commands") || []
      
        commands.each_with_index do |cmd, seconds|
          Global.dispatcher.queue_timer(seconds, "Character backup #{model.name}", client) do
            Global.dispatcher.queue_command(client, Command.new("#{cmd} #{model.name}"))
          end
        end
      
        template = Describe.desc_template(model, enactor)
        client.emit template.render
      end
      
      def export_wiki(model)
        Global.dispatcher.queue_timer(1, "Wiki backup #{model.name}", client) do
          if (model.wiki_char_backup)
            client.emit_ooc t('profile.wiki_backup_avail', :path => model.wiki_char_backup.download_path)
          else
            error = Website.export_char(model)
            if (error)
              client.emit_failure t('profile.wiki_backup_failed', :error => error)
            else
              client.emit_ooc t('profile.wiki_backup_created', :path => model.wiki_char_backup.download_path)
            end
          end
        end
      end
      
    end
  end
end
