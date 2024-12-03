module AresMUSH

  module Describe
    class DescCmd
      include CommandHandler
      
      attr_accessor :target, :description
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.target = trim_arg(args.arg1)
        self.description = args.arg2
      end
      
      def required_args
        [ self.target ]
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client, enactor) do |model|
        
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          model.update_desc(self.description)
          client.emit_success(t('describe.desc_set', :name => model.name))
        end
      end
    end
  end
end
