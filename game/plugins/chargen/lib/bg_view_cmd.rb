module AresMUSH
  module Chargen
    class BgCmd
      include CommandHandler
      
      attr_accessor :target
      
      def parse_args
        self.target = !cmd.args ? enactor_name : trim_arg(cmd.args)
      end
      
      def check_words
        return t('chargen.accidental_view_bg') if (self.target.length > 30)
        return nil
      end
          
      def check_permission
        return nil if self.target == enactor_name
        return nil if Chargen.can_view_bgs?(enactor)
        return t('chargen.no_permission_to_view_bg')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          template = BgTemplate.new(model, model.background)
          client.emit template.render
        end
      end
    end
  end
end
