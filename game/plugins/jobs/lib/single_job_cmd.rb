module AresMUSH
  module Jobs
    module SingleJobCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs

      attr_accessor :number
      
      def initialize(client, cmd, enactor)
        self.required_args = ['number']
        self.help_topic = 'jobs'
        super
      end
      
      def check_number
        return t('jobs.invalid_job_number') if self.number.nil?
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
    end
  end
end
