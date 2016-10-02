module AresMUSH
  module Mail
    class MailReadCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :num
      
      def crack!
        self.num = trim_input(cmd.args)
      end

      def required_args
        {
          args: [ self.num ],
          help: 'mail'
        }
      end
       
      def handle
        Mail.with_a_delivery(client, enactor, self.num) do |delivery|
          template = MessageTemplate.new(enactor, delivery)
          client.emit template.render
          delivery.read = true
          delivery.save
          client.program[:last_mail] = delivery
        end
      end
    end
  end
end
