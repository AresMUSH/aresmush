module AresMUSH
  module Describe
    class DetailEditCmd
      include CommandHandler
      
      attr_accessor :name, :target
      
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
          detail = model.details[self.name]
          
          if (!detail)
            client.emit_failure t('describe.no_such_detail', :name => self.name)
            return
          end
          
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          Utils.grab client, enactor, "detail/set #{self.target}=#{self.name}/#{detail}"
        end
      end
      
    end    
  end
end
