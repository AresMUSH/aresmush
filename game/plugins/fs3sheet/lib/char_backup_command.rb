module AresMUSH

  module FS3Sheet
    class CharBackupCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      
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
          FS3Sheet.sheet_templates.count.times do |i|
            template = FS3Sheet.sheet_templates[i].new(model, client)
            client.emit template.render
          end
          template = InfoTemplate.new(model, client)
          template.render
          Chargen.show_bg(model, client)
          client.emit Describe.char_backup(model, client)
        end
      end
    end
  end
end
