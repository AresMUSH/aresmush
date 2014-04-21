module AresMUSH

  module Describe
    class OutfitSetCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :desc

      def initialize
        self.required_args = ['name', 'desc']
        self.help_topic = 'outfit'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("outfit") && cmd.switch_is?("set")
      end
      
      def crack!
        cmd.crack!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.desc = cmd.args.arg2
      end
      
      def handle
        client.char.outfits[self.name] = self.desc
        client.char.save!
        client.emit_success t('describe.outfit_set')
      end
    end
  end
end
