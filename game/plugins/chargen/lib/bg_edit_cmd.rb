module AresMUSH
  module Chargen
    class BgEditCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :target

      def crack!
        if (!cmd.args)
          self.target = enactor_name
        else
          self.target = trim_input(cmd.args)
        end
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          if (!Chargen.can_edit_bg?(enactor, model, client))
            return
          end
          
          bg = model.background
          if (!bg)
            client.emit_failure 'chargen.bg_not_set'
            return
          end
          
          text = bg.text
          if (self.target == enactor_name)
            Utils::Api.grab client, enactor, "bg/set #{text}"
          else
            Utils::Api.grab client, enactor, "bg/set #{target}=#{text}"
          end
        end
      end
    end
  end
end