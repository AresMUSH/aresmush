module AresMUSH
  module Mail
    # Template for a character's inbox or list of messages.
    class InboxTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      # The character's mail messages.
      # Coder nitpick:  Actually references a list of MailDelivery objects
      attr_accessor :messages
      
      # The tag name
      attr_accessor :tag
      
      def initialize(client, messages, show_from, tag)
        @char = client.char
        @messages = messages
        @show_from = show_from
        @tag = tag
        super client
      end
      
      def build
        text = header()
        
        messages.each_with_index do |msg, i|
          text << "%r"
          text << message_num(i)
          text << " "
          text << message_tags(msg)
          text << " "
          text << message_to_or_from(msg)
          text << " "
          text << message_subject(msg)
          text << " "
          text << message_date(msg)
        end
        
        text << footer()
        
        text << "%r%l1"
        
        text
      end
      
      def header
        text = "%l1%r"
        text << "%xh%x![ #{tag} ]%xn%r"
        text << "%xh#{inbox_title}%xn%r"
        text << "%l2"
        text
      end
      
      def footer
        if (self.tag == Mail.sent_tag)
          "%R%l2%R#{t('mail.sent_mail_notice')}"
        else
          ""
        end
      end
      
      def inbox_title
        @show_from ? t('mail.sent_title') : t('mail.inbox_title')
      end
      
      def message_num(index)
        "#{index+1}".rjust(3)
      end

      def message_subject(msg)
        msg.message.subject.ljust(31)
      end

      def message_date(msg)
        OOCTime.local_short_timestr(self.client, msg.message.created_at)
      end
      
      # Message sent to or sent from, depending on the inbox mode.
      def message_to_or_from(msg)
        @show_from ? message_sent_to(msg) : message_author(msg)
      end
      
      def message_author(msg)
        message = msg.message
        a = message.author.nil? ? t('mail.deleted_author') : message.author.name
        a.ljust(22)
      end
      
      # Message sent to.  Note that this is just the individual recipient of THIS delivery,
      # not a list of all people who received the message.
      def message_sent_to(msg)
        a = msg.character.nil? ? t('mail.deleted_recipient') : msg.character.name
        a.ljust(22)
      end
      
      # Message tags, like unread or marked for deletion
      def message_tags(msg)
        unread = msg.read ? "-" : t('mail.unread_marker')
        trashed = msg.tags.include?(Mail.trashed_tag) ? t('mail.trashed_marker') : "-"
        " [#{unread}#{trashed}]  "
      end
    end
  end
end