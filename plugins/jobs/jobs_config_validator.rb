module AresMUSH
  module Jobs
    class JobsConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("jobs")
      end
      
      def validate
        @validator.require_list('active_statuses')
        @validator.check_cron('archive_cron')
        @validator.require_int('archive_job_days')
        @validator.require_nonblank_text('archived_status')
        @validator.require_list('closed_statuses')
        @validator.require_nonblank_text('default_status')
        @validator.require_nonblank_text('open_status')
        @validator.require_in_list("request_category", Jobs.categories)
        @validator.require_hash('status')
        @validator.require_in_list("system_category", Jobs.categories)
        @validator.require_in_list("trouble_category", Jobs.categories)
        
        schedules = Global.read_config("jobs", "scheduled_jobs") || []
        schedules.each do |sched|
          if (sched["title"].blank?)
            @validator.add_error "jobs:Schedule missing title."
          end
          if (sched["message"].blank?)
            @validator.add_error "jobs:Schedule #{sched['title']} missing message."
          end
          if (!Jobs.categories.include?(sched["category"]))
            @validator.add_error "jobs:Invalid schedule category #{sched['category']} for #{sched['title']}"
          end
          
          @validator.check_cron(sched["cron"])
        end
        
        custom_fields = Global.read_config("jobs", "custom_fields") || []
        if (custom_fields.map { |f| (f['name'] || "").upcase }.uniq.count != custom_fields.count)
          @validator.add_error "jobs: Each custom field must have a unique name."
        end
        
        custom_fields.each do |custom|
          if (custom['name'].blank?)
            @validator.add_error "jobs:Custom field missing name."
          end
          if (!['dropdown', 'text', 'date'].include?(custom['field_type']))
            @validator.add_error "jobs:Custom field #{custom['name']} has an invalid field_type."
          end
          if (custom['field_type'] == 'dropdown' && ((custom['dropdown_values'] || []).count == 0))
            @validator.add_error "jobs:Custom field #{custom['name']} missing dropdown values."
          end
        end        
        
        begin
         
          statuses = Global.read_config('jobs', 'active_statuses')
          if (statuses.empty?)
            @validator.add_error "jobs:active_statuses cannot be empty."
          end
          statuses.each do |s|
            check_status('active_statuses', s)
          end
          statuses = Global.read_config('jobs', 'closed_statuses')
          if (statuses.empty?)
            @validator.add_error "jobs:closed_statuses cannot be empty."
          end
          statuses.each do |s|
            check_status('closed_statuses', s)
          end
          check_status 'archived_status', Global.read_config('jobs', 'archived_status')
          check_status 'default_status', Global.read_config('jobs', 'default_status')
          check_status 'open_status', Global.read_config('jobs', 'open_status')
          
        rescue Exception => ex
          @validator.add_error "Unknown jobs config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end
      
      def check_status(title, status)
        statuses = Global.read_config('jobs', 'status').keys
        if (!statuses.include?(status))
          @validator.add_error "jobs:#{title} #{status} is not a valid status."
        end
      end
    end
  end
end