module AresMUSH

  module FS3Skills
    class CharBackupCmd
      include CommandHandler
      
      attr_accessor :target
      
      def parse_args
        self.target = !cmd.args ? enactor.name : trim_arg(cmd.args)
      end
      
      def check_permission
        return nil if self.target == enactor.name
        return nil if FS3Skills.can_view_sheets?(enactor)
        return t('fs3skills.no_permission_to_backup')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          
          ["sheet", "bg", "profile", "damage", "relationships"].each_with_index do |cmd, seconds|
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
