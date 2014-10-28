module AresMUSH
  module Alts
    class AltsCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'alts'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("alts")
      end
      
      def crack!
        self.name = cmd.args.nil? ? client.name : titleize_input(cmd.args)
      end
      
      def check_slave
        return t('handles.alts_not_available_on_master') if Global.api_router.is_master?
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          if (Handles.find_visible_alts(model.handle, client.char).any?)
            client.emit_failure t('handles.no_alts')
          else
            client.emit BorderedDisplay.list list, t('handles.alts_list', :name => model.name)
          end
        end
      end
    end
  end
end