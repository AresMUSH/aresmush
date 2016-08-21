module AresMUSH
  module Alts
    class AltsCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
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
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          alts_text = Handles.get_visible_alts_name_list(model, client.char)
          footer = "%R#{t('handles.alts_notice')}"
          client.emit BorderedDisplay.text alts_text, t('handles.visible_alts'), true, footer
        end
      end
    end
  end
end