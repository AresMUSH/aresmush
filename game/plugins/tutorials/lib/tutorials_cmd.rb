module AresMUSH
  module Tutorials
    class TutorialsCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginWithoutArgs
      include PluginRequiresLogin

      def want_command?(client, cmd)
        cmd.root_is?("tutorials")
      end
            
      def handle
        tutorials = Tutorials.available_tutorials.map { |k, v| "#{k.titleize.ljust(30)}#{v['desc']}"}
        footer = "%l2%R#{t('tutorials.tutorials_footer')}"
        client.emit BorderedDisplay.list tutorials, t('tutorials.tutorials_title'), footer
      end
    end
  end
end
