module AresMUSH

  module FS3Sheet
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
          template =  WikiTemplate.new(model, client)
          template.render
        end
      end
    end
  end
end
