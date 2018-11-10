module AresMUSH

  module Chargen
    class HooksSetCmd
      include CommandHandler
      
      attr_accessor :target, :hooks
      
      def parse_args
        # Starts with a character name and equals - since names can't have
        # spaces we can check for that.  This allows the hooks themselves to contain ='s.
        if (Chargen.can_approve?(enactor) && cmd.args =~ /^[\S]+\=/)
          self.target = cmd.args.before("=")
          self.hooks = cmd.args.after("=")
        else
          self.target = enactor_name
          self.hooks = cmd.args
        end
      end
      
      def required_args
        [ self.target ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          if (enactor.name == model.name || Chargen.can_approve?(enactor))
            model.update(rp_hooks: self.hooks)
            client.emit_success t('chargen.hooks_set')
          else
            client.emit_failure t('dispatcher.not_allowed')
          end
                    
        end
      end
    end
  end
end
