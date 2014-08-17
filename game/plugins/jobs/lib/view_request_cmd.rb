module AresMUSH
  module Jobs
    class ViewRequestCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :number
      
      def initialize
        self.required_args = ['number']
        self.help_topic = 'request'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("request") && cmd.switch.nil? && cmd.args !~ /\=/
      end
      
      def crack!
        self.number = trim_input(cmd.args)
      end
      
      def check_number
        return nil if self.number.nil?
        return t('jobs.invalid_request_number') if !self.number.is_integer?
        return nil
      end
      
      def handle
        Jobs.with_a_request(client, self.number) do |request|          
          replies = request.job_replies.map { |j| j.message }
          client.emit BorderedDisplay.text("#{request.title} #{request.description} #{replies}")
        end
      end
    end
  end
end
