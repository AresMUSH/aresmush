module AresMUSH
  module Mail
    class MailTagCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :num, :tag

      def initialize
        self.required_args = ['num', 'tag']
        self.help_topic = 'mail managing'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && (cmd.switch_is?("tag") || cmd.switch_is?("untag"))
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.num = trim_input(cmd.args.arg1)
        self.tag = titleize_input(cmd.args.arg2)        
      end
      
      def handle
        Mail.with_a_delivery(client, self.num) do |delivery|
          
          if (cmd.switch_is?("tag"))
            delivery.tags << self.tag
            delivery.tags.uniq!
            client.emit_success t('mail.tag_added', :name => self.tag)
          else
            delivery.tags.delete(self.tag)
            client.emit_success t('mail.tag_removed', :name => self.tag)
          end          
          delivery.save
        end
      end
    end
  end
end
