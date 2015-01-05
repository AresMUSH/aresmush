module AresMUSH

  module Sheet
    class WikiCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      
      attr_accessor :target

      def want_command?(client, cmd)
        cmd.root_is?("wiki")
      end

      def crack!
        self.target = cmd.args.nil? ? client.name : trim_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          client.emit Sheet.wiki_renderer.render(model)
        end
      end
    end
  end
end
