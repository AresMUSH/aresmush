module AresMUSH
  module Chargen
    class HooksEditCmd
      include CommandHandler
      
      attr_accessor :target
      
      def parse_args
        if (!cmd.args)
          self.target = enactor_name
        else
          self.target = trim_arg(cmd.args)
        end
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          if (enactor.name == model.name || Chargen.can_approve?(enactor))
            if (self.target == enactor_name)
              Utils.grab client, enactor, "hooks/set #{model.rp_hooks}"
            else
              Utils.grab client, enactor, "hooks/set #{target}=#{model.rp_hooks}"
            end
          else
            client.emit_failure t('dispatcher.not_allowed')
          end
        end
      end
    end
  end
end