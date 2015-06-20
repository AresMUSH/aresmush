module AresMUSH
  module Chargen
    class BgSetCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :target, :background

      def initialize
        self.required_args = ['target', 'background']
        self.help_topic = 'bg'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bg") && cmd.switch_is?("set")
      end
            
      def crack!
        # Starts with a character name and equals - since names can't have
        # spaces we can check for that.  This allows the BG itself to contain ='s.
        if (cmd.args =~ /^[\S]+\=/)
          self.target = cmd.args.before("=")
          self.background = cmd.args.after("=")
        else
          self.target = client.name
          self.background = cmd.args
        end
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          if (!Chargen.can_edit_bg?(client.char, model, client))
            return
          end
          
          model.background = self.background
          model.save
          client.emit_success t('chargen.bg_set')
        end
      end
    end
  end
end