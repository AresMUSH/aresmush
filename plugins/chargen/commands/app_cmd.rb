module AresMUSH
  module Chargen
    class AppCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = !cmd.args ? enactor_name : trim_arg(cmd.args)
      end
      
      def check_can_review
        return nil if self.name == enactor_name
        return nil if Chargen.can_approve?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle        
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (model.is_approved?)
            if (model == enactor)
              client.emit_failure t('chargen.you_are_already_approved')
            else
              client.emit_failure t('chargen.already_approved', :name => model.name)
            end
            return
          end
          
          template = AppTemplate.new(model, enactor)
          client.emit template.render
        end
      end      
    end
  end
end