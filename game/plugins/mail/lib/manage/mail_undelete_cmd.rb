module AresMUSH
  module Mail
    class MailUndeleteCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :num
      
      def initialize
        self.required_args = ['num']
        self.help_topic = 'mail managing'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("undelete")
      end
      
      def crack!
        self.num = trim_input(cmd.args)
      end
            
      def handle
        Mail.with_a_delivery(client, self.num) do |delivery|
          delivery.tags.delete(Mail.trashed_tag)
          delivery.save
          client.emit_ooc t("mail.message_undeleted", :subject => delivery.message.subject)
        end
      end
    end
  end
end
