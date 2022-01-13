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