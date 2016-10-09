module AresMUSH
  module Mail
    # Template for an individual mail message
    class InboxTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :tag, :messages
      
      def initialize(enactor, messages, show_from, tag)
        @enactor = enactor
        @messages = messages
        @show_from = show_from
        @tag = tag
        super File.dirname(__FILE__) + "/inbox.erb"
      end
      
      def filters_enabled
        @tag != Mail.inbox_tag
      end
        
      def tag_title
        if (@tag.start_with?("review"))
          return t('mail.sent_review', :name => @tag.after(" "))
        end
        @tag
      end
      
      def header
        @show_from ? t('mail.inbox_title') : t('mail.sent_title') 
      end
      
      def is_sent_mail
        @tag == Mail.sent_tag
      end
      
      def date(msg)
        OOCTime::Api.local_short_timestr(@enactor, msg.created_at)
      end
      
      # Message sent to or sent from, depending on the inbox mode.
      def to_or_from(msg)
        @show_from ? author(msg) : msg.to_list
      end
      
      def author(msg)
        !msg.author ? t('mail.deleted_author') : msg.author.name
      end
      
      # Message sent to.  Note that this is just the individual recipient of THIS delivery,
      # not a list of all people who received the message.
      def sent_to(msg)
        !msg.character ? t('mail.deleted_recipient') : msg.character.name
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