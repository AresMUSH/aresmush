module AresMUSH
  module Mail
    class MailTagCmd
      include CommandHandler

      attr_accessor :num, :tag
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.num = trim_arg(args.arg1)
        self.tag = titlecase_arg(args.arg2)        
      end
      
      def required_args
        [ self.num, self.tag ]
      end
      
      def handle
        
        messages_to_tag = Mail.select_message_range(self.num)
        if (!messages_to_tag)
          client.emit_failure t('mail.invalid_message_number')
          return
        end
        
        messages_to_tag.each do |m|          
          Mail.with_a_delivery(client, enactor, "#{m}") do |delivery|
            tags = delivery.tags || []
            if (cmd.switch_is?("tag"))
              tags << self.tag
              tags.uniq!
              delivery.update(tags: tags)
              client.emit_success t('mail.tag_added', :name => self.tag)
            else
              tags.delete self.tag
              if (tags.empty?)
                client.emit_failure t('mail.tags_cant_be_empty')
                return
              end
              delivery.update(tags: tags)
              client.emit_success t('mail.tag_removed', :name => self.tag)
            end          
          end
        end
      end
    end
  end
end
