module AresMUSH

  module Chargen
    class HooksViewCmd
      include CommandHandler
      
      attr_accessor :target
      
      def parse_args
        self.target = !cmd.args ? enactor_name : titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.target ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          formatter = MarkdownFormatter.new
          hooks = formatter.to_mush model.rp_hooks
          template = BorderedDisplayTemplate.new hooks, t('chargen.hooks_title', :name => model.name)
          client.emit template.render
          
        end
      end
    end
  end
end
