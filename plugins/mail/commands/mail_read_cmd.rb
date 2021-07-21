module AresMUSH
  module Mail
    class MailReadCmd
      include CommandHandler
           
      attr_accessor :num
      
      def parse_args
        self.num = trim_arg(cmd.args)
      end

      def required_args
        [ self.num ]
      end
       
      def handle
        Mail.with_a_delivery(client, enactor, self.num) do |delivery|
          thread = delivery.thread ? delivery.thread : delivery
          template = MessageTemplate.new(enactor, thread)
          client.emit template.render
          Mail.mark_read(thread, enactor)
          client.program[:last_mail] = delivery
        end
      end
    end
  end
end
