module AresMUSH
  module Jobs
    class ViewRequestCmd
      include CommandHandler

      attr_accessor :number

      def parse_args
        self.number = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.number ]
      end
      
      def check_number
        return nil if !self.number
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def handle
        Jobs.with_a_request(client, enactor, self.number) do |request|
          template = JobTemplate.new(enactor, request)            
          client.emit template.render
          Jobs.mark_read(request, enactor)
        end
      end
    end
  end
end
