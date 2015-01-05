module AresMUSH
  module Mail
    # Template for a character's inbox.
    class InboxTemplate
      include TemplateFormatters
      
      # The character's mail messages.
      # Usually you would use this in a list with a counter, like so:
      # Inside the loop, each exit would be referenced as 'e'
      #    <% messages.each_with_index do |m, i| -%>
      #    <%= message_num(i) %> <%= message_date(m) %>
      #    <% end %>
      # Coder nitpick:  Actually references a list of MailDelivery objects
      attr_accessor :messages
      
      # The folder name
      attr_accessor :folder
      
      def initialize(client, messages, show_from, folder)
        @client = client
        @char = client.char
        @messages = messages
        @show_from = show_from
        @folder = folder
      end
      
      def inbox_title
        @show_from ? t('mail.sent_title') : t('mail.inbox_title')
      end
      
      # Message number.  
      # Requires a message index counter.  See 'messages' for more info.
      def message_num(index)
        "#{index+1}".rjust(3)
      end

      # Message subject.
      # Requires a message reference.  See 'messages' for more info.
      def message_subject(msg)
        msg.message.subject.ljust(31)
      end

      # Message delivery date
      # Requires a message reference.  See 'messages' for more info.
      def message_date(msg)
        OOCTime.local_short_timestr(@client, msg.message.created_at)
      end
      
      # Message sent to or sent from, depending on the inbox mode.
      # Requires a message reference.  See 'messages' for more info.
      def message_to_or_from(msg)
        @show_from ? message_sent_to(msg) : message_author(msg)
      end
      
      # Message author
      # Requires a message reference.  See 'messages' for more info.
      def message_author(msg)
        message = msg.message
        a = message.author.nil? ? t('mail.deleted_author') : message.author.name
        a.ljust(22)
      end
      
      # Message sent to.  Note that this is just the individual recipient of THIS delivery,
      # not a list of all people who received the message.
      # Requires a message reference.  See 'messages' for more info.
      def message_sent_to(msg)
        a = msg.character.nil? ? t('mail.deleted_recipient') : msg.character.name
        a.ljust(22)
      end
      
      # Message tags, like unread or marked for deletion
      # Requires a message reference.  See 'messages' for more info.
      def message_tags(msg)
        unread = msg.read ? "-" : t('mail.unread_marker')
        trashed = msg.trashed ? t('mail.trashed_marker') : "-"
        " [#{unread}#{trashed}]  "
      end
    end
  end
end