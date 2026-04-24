module AresMUSH

  module Profile
    class CharBackupCmd
      include CommandHandler
      
      attr_accessor :target, :game_export
      
      def parse_args
        self.target = !cmd.args ? enactor.name : titlecase_arg(cmd.args)
        self.game_export = cmd.switch_is?("game")
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          
          if (self.game_export)
            self.export_game(model)
          else
            error = Profile.export_wiki_char(model)
            if (error)
              client.emit_failure error
            else
              client.emit_success t('profile.wiki_backup_in_progress')
            end
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
    end
  end
end
