module AresMUSH    
  module Swade
    class ChargenpointsCmd
      include CommandHandler

      attr_accessor :target_name
  
      def parse_args
         self.target_name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end
  
      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
           template = ChargenpointsTemplate.new(model)
           client.emit template.render
        end
      end
    end
  end
end