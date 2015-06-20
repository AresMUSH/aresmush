module AresMUSH
  module Mail
    class MailReadCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :num
      
      def initialize
        self.required_args = ['num']
        self.help_topic = 'mail'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch.nil? && !cmd.args.nil? && cmd.args !~ /[\/\=]/
      end
      
      def crack!
        self.num = trim_input(cmd.args)
      end
            
      def handle
        Mail.with_a_delivery(client, self.num) do |delivery|
          template = MessageTemplate.new(client, delivery)
          client.emit template.display
          delivery.read = true
          delivery.save
          client.program[:last_mail] = delivery
        end
      end
    end
  end
end
