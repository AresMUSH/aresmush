module AresMUSH

  module Sheet
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
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          Sheet.sheet_renderers.count.times do |i|
            renderer = Sheet.sheet_renderers[i]
            client.emit renderer.render(model)
          end
          client.emit Describe.char_backup(model, client)
        end
      end
    end
  end
end
