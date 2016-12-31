module AresMUSH
  module Mail
    class MailTagCmd
      include CommandHandler

      attr_accessor :num, :tag
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.num = trim_input(cmd.args.arg1)
        self.tag = titleize_input(cmd.args.arg2)        
      end
      
      def required_args
        {
          args: [ self.num, self.tag ],
          help: 'mail tags'
        }
      end
      
      def handle
        Mail.with_a_delivery(client, enactor, self.num) do |delivery|
          
          tags = delivery.tags
          if (cmd.switch_is?("tag"))
            tags << self.tag
            tags = tags.uniq!
            delivery.update(tags: tags)
            client.emit_success t('mail.tag_added', :name => self.tag)
          else
            tags.delete self.tag
            delivery.update(tags: tags)
            
            client.emit_success t('mail.tag_removed', :name => self.tag)
          end          
        end
      end
    end
  end
end
