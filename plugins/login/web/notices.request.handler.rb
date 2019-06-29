module AresMUSH
  module Login
    class LoginNoticesRequestHandler
      def handle(request)      
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        notices = enactor.login_notices
        
        response = notices.to_a.sort_by { |n| n.created_at }.reverse.map { |n| {
          message: Website.format_markdown_for_html(n.message),
          data: n.data ? n.data.split("|") : [],
          type: n.type,
          is_unread: n.is_unread,
          timestamp: OOCTime.local_long_timestr(enactor, n.created_at)
        }}
        
        notices.find(is_unread: true).each { |n| n.update(is_unread: false)}
        
        response
      end
    end
  end
end