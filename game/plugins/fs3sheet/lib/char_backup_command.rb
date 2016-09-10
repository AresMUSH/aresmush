module AresMUSH

  module FS3Sheet
    class CharBackupCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      
      attr_accessor :target

      def want_command?(client, cmd)
        cmd.root_is?("backup")
      end

      def crack!
        self.target = cmd.args.nil? ? client.name : trim_input(cmd.args)
      end
      
      def check_permission
        return nil if self.target == client.name
        return nil if client.char.has_any_role?(Global.read_config("sheet", "roles", "can_view_sheets"))
        return t('sheet.no_permission_to_backup')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          Global.dispatcher.queue_command(client, Command.new("sheet #{model.name}"))
          Global.dispatcher.queue_command(client, Command.new("bg #{model.name}"))
          Global.dispatcher.queue_command(client, Command.new("info #{model.name}"))
          
          template = Describe.get_desc_template(model, client)
          template.render
        end
      end
    end
  end
end
