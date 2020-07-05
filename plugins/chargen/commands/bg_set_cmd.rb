module AresMUSH
  module Chargen
    class BgSetCmd
      include CommandHandler
      
      attr_accessor :target, :background
      
      def parse_args
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
        [ self.target, self.background ]
      end

      def check_chargen_locked
        return nil if Chargen.can_manage_apps?(enactor)        
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          error = Chargen.check_can_edit_bg(enactor, model)
          if (error)
            client.emit_failure error
            return
          end
                              
          model.update(cg_background: self.background)
          client.emit_success t('chargen.bg_set')
        end
      end
    end
  end
end