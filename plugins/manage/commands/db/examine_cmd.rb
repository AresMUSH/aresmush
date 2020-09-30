module AresMUSH
  module Manage
    class ExamineCmd
      include CommandHandler
      
      attr_accessor :target, :attr_name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_optional_arg2)
        self.target = trim_arg(args.arg1)
        self.attr_name = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.target ]
      end
      
      def handle
        search = VisibleTargetFinder.find(self.target, enactor)
        if (search.found?)
          model = search.target
        else
          search = AnyTargetFinder.find(self.target, enactor)

          if (!search.found?)
            client.emit_failure search.error
            return
          end
          model = search.target
        end
        
        if (!Manage.can_manage_object?(enactor, model))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end

        line = "-".repeat(78)
        if (self.attr_name)
          attr_val = model.attributes[self.attr_name.to_sym]
          display = "#{line}\n#{self.attr_name}: #{attr_val}\n#{line}"
        else
          json = model.print_json
          display = "#{line}\n#{model.name} (#{model.dbref})\n\n#{json}#{}\n#{line}"
        end
        
        client.emit_raw display
      end
      
      def print_model
      end
    end
  end
end
