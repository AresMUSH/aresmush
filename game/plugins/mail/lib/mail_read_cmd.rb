module AresMUSH
  module Mail
    class MailReadCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :num
      
      def initialize(client, cmd, enactor)
        self.required_args = ['num']
        self.help_topic = 'mail'
        super
      end
      
      def crack!
        self.num = trim_input(cmd.args)
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
