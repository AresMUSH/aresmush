module AresMUSH
  module Jobs
    class RequestFilterCmd
      include CommandHandler
      
      attr_accessor :filter
      
      def parse_args
        self.filter = cmd.args ? trim_arg(cmd.args.upcase) : nil
      end

      def required_args
        [ self.filter ]
      end
      
      def check_filter_type
        types = ["ACTIVE", "ALL"]
        return t('jobs.invalid_filter_type', :names => types) if !types.include?(self.filter)
        return nil
      end
      
      def handle
        enactor.update(jobs_filter: self.filter)
        Global.dispatcher.queue_command(client, Command.new("requests"))
      end
    end
  end
end
