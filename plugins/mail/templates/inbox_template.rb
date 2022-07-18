module AresMUSH
  module Mail
    # Template for an individual mail message
    class InboxTemplate < ErbTemplateRenderer
      
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
      
      def mail_header
        @show_from ? t('mail.inbox_title') : t('mail.sent_title') 
      end
      
      def is_sent_mail
        @tag == Mail.sent_tag
      end
      
      def date(msg)
        msg.created_date_str(@enactor)
      end
      
      # Message sent to or sent from, depending on the inbox mode.
      def to_or_from(msg)
        @show_from ? author(msg) : msg.to_list
      end
      
      def author(msg)
        msg.author_name
      end
      
      # Message sent to.  Note that this is just the individual recipient of THIS delivery,
      # not a list of all people who received the message.
      def sent_to(msg)
        !msg.character ? t('mail.deleted_character') : msg.character.name
      end
      
      # Message tags, like unread or marked for deletion
      def tags(msg)
        unread = msg.read ? "-" : t('mail.unread_marker')
        trashed = msg.tags.include?(Mail.trashed_tag) ? t('mail.trashed_marker') : "-"
        " #{start_marker}#{unread}#{trashed}#{end_marker}  "
      end
     
      def start_marker
        Mail.start_marker
      end
      
      def end_marker
        Mail.end_marker
      end
    end
  end
end