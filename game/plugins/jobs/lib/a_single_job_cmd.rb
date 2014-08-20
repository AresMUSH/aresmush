module AresMUSH
  module Jobs
    module SingleJobCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :number
      
      def initialize
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
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(client.char)
        return nil
      end
    end
  end
end
