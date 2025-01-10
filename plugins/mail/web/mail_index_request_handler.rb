module AresMUSH
  module Mail
    class MailIndexRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        chars = []
        
        AresCentral.alts(enactor).each do |char|
        
          Mail.empty_old_trash(char)
        
          tags = Mail.all_tags(char)
          mail = char.mail.to_a.sort_by { |m| m.created_at }
             .reverse
             .map { |m| {
              id: m.id,
              subject: m.subject,
              to_list: m.to_list,
              from: m.author_name,
              created: m.created_date_str(char),
              is_in_trash: m.tags.include?(Mail.trashed_tag),
              tags: m.tags,
              can_reply: m.author,
              unread: !m.read,
              body: Website.format_markdown_for_html(m.body)
              }}
        
          unread_count = char.unread_mail.count
          chars << {
            name:  char.name,
            id: char.id,
            unread_count: unread_count,
            has_unread: unread_count > 0,
            mail: mail,
            tags: tags
          }
        end
        
        chars
      end
    end
  end
end