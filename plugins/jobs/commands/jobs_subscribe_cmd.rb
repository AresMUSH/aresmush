module AresMUSH
  module Jobs
    class JobsSubscribeCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = cmd.switch_is?("subscribe")
      end

      def check_can_access
        return t('jobs.cant_access_jobs') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def handle
        enactor.update(jobs_subscription: self.option)
        client.emit_success self.option ? t('jobs.jobs_subscription_on') : t('jobs.jobs_subscription_off')
      end
    end
  end
end
