module AresMUSH    
  module Fate
    class SheetCmd
      include CommandHandler

      attr_accessor :target_name
  
      def parse_args
         self.target_name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end
  
      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
           template = SheetTemplate.new(model)
           client.emit template.render
        end
      end
    end
  end
end