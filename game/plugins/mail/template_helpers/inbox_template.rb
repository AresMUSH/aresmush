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
      
      def initialize(client)
        @client = client
        @char = client.char
        @messages = @char.mail
      end
      
      # Folder name
      def folder
        "Inbox"
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
      
      # Message author
      # Requires a message reference.  See 'messages' for more info.
      def message_author(msg)
        message = msg.message
        a = message.author.nil? ? t('mail.deleted_author') : message.author.name
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