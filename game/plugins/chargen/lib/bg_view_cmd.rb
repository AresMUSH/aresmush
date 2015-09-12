module AresMUSH
  module Chargen
    class BgCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :target, :page
      
      def want_command?(client, cmd)
        cmd.root_is?("bg") && !cmd.switch
      end

      def crack!
        self.target = cmd.args.nil? ? client.name : trim_input(cmd.args)
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def check_permission
        return nil if self.target == client.name
        return nil if Chargen.can_view_bgs?(client.char)
        return t('chargen.no_permission_to_view_bg')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          Chargen.show_bg(model, client)
        end
      end
    end
  end
end
