module AresMUSH
  module Mail
    class MailMessageRequestHandler
      def handle(request)
        enactor = request.enactor
        message = MailMessage[request.args[:id]]
        
        error = Website.check_login(request)
        return error if error

        if (!message)
          return { error: t('db.object_not_found') }
        end
        
        if (message.character != enactor)
          return { error: t('dispatcher.not_allowed') }
        end
        
        message.mark_read
        
       {
            id: message.id,
            subject: message.subject,
            to_list: message.to_list,
            reply_all:  Mail.reply_list(message, enactor, true).join(" "),
            from: message.author_name,
            created: message.created_date_str(enactor),
            tags: message.tags,
            can_reply: !!message.author,
            unread: !message.read,
            body: Website.format_markdown_for_html(message.body),
            all_tags: Mail.all_tags(enactor),
            in_trash: message.tags.include?(Mail.trashed_tag),
            raw_body: message.body,
            unread_mail_count: enactor.num_unread_mail
        }
      end
    end
  end
end