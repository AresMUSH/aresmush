module AresMUSH
  module Chargen
    class BgSetCmd
      include CommandHandler
      
      attr_accessor :target, :background
 
      def crack!
        # Starts with a character name and equals - since names can't have
        # spaces we can check for that.  This allows the BG itself to contain ='s.
        if (cmd.args =~ /^[\S]+\=/)
          self.target = cmd.args.before("=")
          self.background = cmd.args.after("=")
        else
          self.target = enactor_name
          self.background = cmd.args
        end
      end
      
      def required_args
        {
          args: [ self.target, self.background ],
          help: 'bg'
        }
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          if (!Chargen.can_edit_bg?(enactor, model, client))
            return
          end
                    
          model.update(cg_background: self.background)
          client.emit_success t('chargen.bg_set')
        end
      end
    end
  end
end