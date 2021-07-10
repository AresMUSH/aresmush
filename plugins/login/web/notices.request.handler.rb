module AresMUSH
  module Login
    class LoginNoticesRequestHandler
      def handle(request)      
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        chars = []
        total_unread = 0
        
        AresCentral.alts(enactor).each do |char|
        
          notices = char.login_notices
        
          notice_data = notices.to_a.sort_by { |n| [ n.is_unread ? 1 : 0, n.timestamp ] }.reverse.map { |n| {
            id: n.id,
            message: Website.format_markdown_for_html(n.message),
            data: n.data ? n.data.split("|") : [],
            reference_id: n.reference_id,
            type: n.type,
            is_unread: n.is_unread,
            timestamp: OOCTime.local_long_timestr(enactor, n.timestamp),
          }}
          
          unread_count = notices.select { |n| n.is_unread }.count
          total_unread = total_unread + unread_count
        
          chars << {
            name: char.name,
            is_alt: char != enactor,
            notices: notice_data,
            unread_count: unread_count,
            has_unread: unread_count > 0
          }
        end
        
                
        {
          total_unread: total_unread,
          chars: chars.sort { |c| c[:is_alt] ? 1 : 0 }
        }
      end
    end
  end
end