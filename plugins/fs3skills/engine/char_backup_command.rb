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
          Engine.dispatcher.queue_command(client, Command.new("sheet #{model.name}"))
          Engine.dispatcher.queue_command(client, Command.new("bg #{model.name}"))
          Engine.dispatcher.queue_command(client, Command.new("info #{model.name}"))
          
          template = Describe.desc_template(model, enactor)
          client.emit template.render
        end
      end
    end
  end
end
