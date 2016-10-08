module AresMUSH
  module Jobs
    module ChangeJobCmd
      include SingleJobCmd
      
      attr_accessor :value

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.value = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.number, self.value ],
          help: 'jobs'
        }
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          update_value(job)
          notification = t('jobs.updated_job', :number => job.number, :title => job.title, :name => enactor_name)
          Jobs.notify(job, notification, enactor)
        end
      end
      
      def update_value(job)
        raise "Not implemented."
      end
    end
    
    class ChangeTitleCmd
      include ChangeJobCmd

      def update_value(job)
        job.update(title: self.value)
      end
    end
    
    class ChangeCategoryCmd
      include ChangeJobCmd
      
      def check_category
        return nil if !self.value
        return t('jobs.invalid_category', :categories => Jobs.categories) if (!Jobs.categories.include?(self.value.upcase))
        return nil
      end
      
      def update_value(job)
        job.update(category: self.value.upcase)
      end
    end
    
  end
end
