module AresMUSH
  module Jobs
    module SingleJobCmd
      include CommandHandler

      attr_accessor :number

      def required_args
        [ self.number ]
      end
      
      def check_number
        return t('jobs.invalid_job_number') if !self.number
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def check_can_access
        return t('jobs.cant_access_jobs') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
    end
  end
end
