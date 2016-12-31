module AresMUSH
  module Jobs
    class ViewRequestCmd
      include CommandHandler

      attr_accessor :number

      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.number ],
          help: 'requests'
        }
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
