module AresMUSH
  module Jobs
    class ViewRequestCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs

      attr_accessor :number
      
      def initialize
        self.required_args = ['number']
        self.help_topic = 'requests'
        super
      end
      
      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def check_number
        return nil if self.number.nil?
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def handle
        Jobs.with_a_request(client, self.number) do |request|
          template = JobTemplate.new(client, request)            
          client.emit template.render
          Jobs.mark_read(request, client.char)
        end
      end
    end
  end
end
