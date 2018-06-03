module AresMUSH

  module Describe
    class DetailSetCmd
      include CommandHandler
            
      attr_accessor :name, :target, :desc
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.target = trim_arg(args.arg1)
        self.name = titlecase_arg(args.arg2)
        self.desc = args.arg3
      end
      
      def required_args
        [ self.target, self.desc, self.name ]
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.target, client, enactor) do |model|
                    
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          details = model.details
          details[self.name] = self.desc
          model.update(details: details)

          client.emit_success t('describe.detail_set')
        end
      end
    end
  end
end
