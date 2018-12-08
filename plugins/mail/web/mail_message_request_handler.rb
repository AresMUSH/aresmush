module AresMUSH
  module Mail
    class MailMessageRequestHandler
      def handle(request)
        enactor = request.enactor
        message = MailMessage[request.args[:id]]
        
        error = Website.check_login(request)
        return error if error

        if (!message)
          return { error: t('webportal.missing_required_fields') }
        end
        
        if (message.character != enactor)
          return { error: t('dispatcher.not_allowed') }
        end
        
        message.mark_read
        
       {
            id: message.id,
            subject: message.subject,
            to_list: message.to_list,
            from: message.author_name,
            created: message.created_date_str(enactor),
            tags: message.tags,
            can_reply: !!message.author,
            unread: !message.read,
            body: Website.format_markdown_for_html(message.body),
            in_trash: message.tags.include?(Mail.trashed_tag),
            raw_body: message.body,
            unread_mail_count: enactor.num_unread_mail
        }
      end
    end
  end
end