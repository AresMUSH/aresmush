module AresMUSH
  module Jobs
    class JobsFilterCmd
      include CommandHandler
      
      attr_accessor :filter
      
      def parse_args
        self.filter = cmd.args ? trim_arg(cmd.args.upcase) : nil
      end

      def required_args
        [ self.filter ]
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        return nil
      end
      
      def check_filter_type
        types = ["ACTIVE", "MINE"].concat(Jobs.categories)
        return t('jobs.invalid_filter_type', :names => types) if !types.include?(self.filter)
        nil
      end
      
      def handle
        enactor.update(jobs_filter: self.filter)
        Global.dispatcher.queue_command(client, Command.new("jobs"))
      end
    end
  end
end
