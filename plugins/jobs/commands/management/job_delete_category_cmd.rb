module AresMUSH
  module Jobs
    class DeleteJobCategoryCmd
      include CommandHandler
           
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Forum.can_manage_forum?(enactor)
        return nil
      end
      
      def handle
        Jobs.with_a_category(self.name, client, enactor) do |category|
          if (category.jobs.count > 0)
            client.emit_failure t('jobs.only_delete_empty_categories')
            return
          end
          
          if (JobCategory.all.count == 1)
            client.emit_failure t('jobs.cant_delete_only_category') 
            return
          end
          
          category.delete
          client.emit_success t('jobs.category_deleted')
        end
      end
    end
  end
end
