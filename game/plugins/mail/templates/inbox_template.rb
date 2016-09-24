module AresMUSH
  module Mail
    # Template for an individual mail message
    class InboxTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :tag, :messages
      
      def initialize(client, messages, show_from, tag)
        @client = client
        @messages = messages
        @show_from = show_from
        @tag = tag
        super File.dirname(__FILE__) + "/inbox.erb"
      end
      
      def filters_enabled
        @tag != Mail.inbox_tag
      end
        
      def inbox_title
        @show_from ? t('mail.sent_title') : t('mail.inbox_title')
      end
      
      def is_sent_mail
        @tag == Mail.sent_tag
      end
      
      def date(msg)
        OOCTime::Api.local_short_timestr(@client, msg.created_at)
      end
      
      # Message sent to or sent from, depending on the inbox mode.
      def to_or_from(msg)
        @show_from ? sent_to(msg) : author(msg)
      end
      
      def author(msg)
        msg.author.nil? ? t('mail.deleted_author') : msg.author.name
      end
      
      # Message sent to.  Note that this is just the individual recipient of THIS delivery,
      # not a list of all people who received the message.
      def sent_to(msg)
        msg.character.nil? ? t('mail.deleted_recipient') : msg.character.name
      end
      
      # Message tags, like unread or marked for deletion
      def tags(msg)
        unread = msg.read ? "-" : t('mail.unread_marker')
        trashed = msg.tags.include?(Mail.trashed_tag) ? t('mail.trashed_marker') : "-"
        " [#{unread}#{trashed}]  "
      end
     
    end
  end
end