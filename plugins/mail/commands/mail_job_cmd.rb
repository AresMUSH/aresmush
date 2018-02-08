module AresMUSH
  module Mail
    class MailJobCmd
      include CommandHandler
           
      attr_accessor :num
      
      def parse_args
        self.num = trim_arg(cmd.args)
      end

      def required_args
        [ self.num ]
      end
      
      def check_can_create_jobs
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(enactor)
        nil
      end
       
      def handle
        Mail.with_a_delivery(client, enactor, self.num) do |delivery|
          Jobs.create_job(Jobs.request_category, 
          delivery.subject,
          delivery.body,
          delivery.author)
        end
      end
    end
  end
end
