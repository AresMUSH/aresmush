module AresMUSH
  module Jobs
    class JobCategoryColorCmd
      include CommandHandler

      attr_accessor :name, :color
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.color = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.color ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Jobs.can_manage_jobs?(enactor)
        return nil
      end
      
      def handle
        Jobs.with_a_category(name, client, enactor) do |category|        
          category.update(color: self.color)
          client.emit_success t('jobs.category_color_set')
        end
      end
    end
  end
end
