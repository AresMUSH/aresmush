module AresMUSH
  module Jobs
    
    class RenameJobCategoryCmd
      include CommandHandler

      attr_accessor :name, :new_name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.new_name = upcase_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.new_name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Jobs.can_manage_jobs?(enactor)
        return nil
      end
      
      def handle
        if (JobCategory.named(self.new_name))
          client.emit_failure t('jobs.category_already_exists')
          return
        end
        
        Jobs.with_a_category(name, client, enactor) do |category| 
          category.update(name: self.new_name)
          client.emit_success t('jobs.category_renamed')
        end
      end
    end
  end
end
