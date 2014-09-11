module AresMUSH
  module Jobs
    module ChangeJobCmd
      include SingleJobCmd
      
      attr_accessor :value
      
      def initialize
        self.required_args = ['number', 'value']
        self.help_topic = 'jobs'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.number = trim_input(cmd.args.arg1)
        self.value = cmd.args.arg2
      end
      
      def handle
        Jobs.with_a_job(client, self.number) do |job|
          update_value(job)
          job.save
          notification = t('jobs.updated_job', :number => job.number, :title => job.title, :name => client.name)
          Jobs.notify(job, notification, client.char)
        end
      end
      
      def update_value(job)
        raise "Not implemented."
      end
    end
    
    class ChangeStatusCmd
      include ChangeJobCmd

      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch_is?("status")
      end

      def check_status
        return nil if self.value.nil?
        return t('jobs.invalid_status', :statuses => Jobs.status_vals) if (!Jobs.status_vals.include?(self.value.upcase))
        return nil
      end

      def update_value(job)
        job.status = self.value.upcase        
      end
    end
    
    class ChangeTitleCmd
      include ChangeJobCmd

      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch_is?("title")
      end

      def update_value(job)
        job.title = self.value
      end
    end
    
    class ChangeCategoryCmd
      include ChangeJobCmd

      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch_is?("cat")
      end
      
      def check_category
        return nil if self.value.nil?
        return t('jobs.invalid_category', :categories => Jobs.categories) if (!Jobs.categories.include?(self.value.upcase))
        return nil
      end
      
      def update_value(job)
        job.category = self.value.upcase
      end
    end
    
  end
end
