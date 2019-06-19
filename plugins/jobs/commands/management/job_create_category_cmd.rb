module AresMUSH
  module Jobs
    class CreateJobCategoryCmd
      include CommandHandler
           
      attr_accessor :name

      def parse_args
        self.name = upcase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Jobs.can_manage_jobs?(enactor)
        return nil
      end
      
      def handle
        if (JobCategory.named(self.name))
          client.emit_failure t('jobs.category_already_exists')
          return
        end
        
        category = JobCategory.create(name: self.name)
        client.emit_success t('jobs.category_created')
      end
    end
  end
end
