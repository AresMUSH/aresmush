module AresMUSH
  module Chargen
    class BgEditCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :target

      def crack!
        if (cmd.args.nil?)
          self.target = enactor_name
        else
          self.target = trim_input(cmd.args)
        end
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          if (!Chargen.can_edit_bg?(enactor, model, client))
            return
          end
          
          if (self.target == enactor_name)
            client.grab "bg/set #{model.background}"
          else
            client.grab "bg/set #{target}=#{model.background}"
          end
        end
      end
    end
  end
end