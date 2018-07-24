module AresMUSH
  module Mail
    class MailIndexRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        tags = Mail.all_tags(enactor).select { |t| t != Mail.inbox_tag }.sort
        mail = enactor.mail.map { |m| {
            id: m.id,
            subject: m.subject,
            to_list: m.to_list,
            from: m.author_name,
            created: m.created_date_str(enactor),
            tags: m.tags,
            can_reply: m.author,
            unread: !m.read,
            body: Website.format_markdown_for_html(m.body)
            }}
        
        { 
          unread_count: enactor.unread_mail.count,
          mail: mail,
          tags: tags
        }
      end
    end
  end
end