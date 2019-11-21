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
end
