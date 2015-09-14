module AresMUSH
  module FS3Sheet
    class InfoViewCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :target
      
      def want_command?(client, cmd)
        cmd.root_is?("info") && cmd.switch.nil?
      end

      def crack!
        self.target = cmd.args.nil? ? client.name : trim_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          template = InfoTemplate.new(model, client)
          template.render
        end
      end
    end
  end
end