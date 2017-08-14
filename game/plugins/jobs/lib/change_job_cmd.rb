module AresMUSH
  module Jobs
    module ChangeJobCmd
      include SingleJobCmd
      
      attr_accessor :value

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.number = trim_arg(args.arg1)
        self.value = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.number, self.value ]
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

      def help
        "`job/title <#>=<title>` - Changes a job's title."
      end
      
      def update_value(job)
        job.update(title: self.value)
      end
    end
    
    class ChangeCategoryCmd
      include ChangeJobCmd
      
      def help
        "`job/cat <#>=<category>` - Changes a job's category."
      end
      
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
