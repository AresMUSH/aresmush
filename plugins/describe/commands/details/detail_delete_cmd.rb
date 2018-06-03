module AresMUSH
  module Describe
    class DetailDeleteCmd
      include CommandHandler
           
      attr_accessor :target, :name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
        self.target = trim_arg(args.arg1)
        self.name = titlecase_arg(args.arg2)
      end
      
      def required_args
        [ self.target, self.name ]
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.target, client, enactor) do |model|
          
          if (!model.details.has_key?(self.name))
            client.emit_failure t('describe.no_such_detail', :name => self.name)
            return
          end
          
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          details = model.details
          details.delete self.name
          model.update(details: details)
          client.emit_success t('describe.detail_deleted')
        end
      end
    end
  end
end
