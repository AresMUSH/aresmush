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
          
          if (self.target == enactor_name)
            Utils::Api.grab client, enactor, "bg/set #{model.background}"
          else
            Utils::Api.grab client, enactor, "bg/set #{target}=#{model.background}"
          end
        end
      end
    end
  end
end