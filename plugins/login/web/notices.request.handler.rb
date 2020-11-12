module AresMUSH
  module Login
    class LoginNoticesRequestHandler
      def handle(request)      
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        notices = enactor.login_notices
        
        notice_data = notices.to_a.sort_by { |n| [ n.is_unread ? 1 : 0, n.timestamp ] }.reverse.map { |n| {
          id: n.id,
          message: Website.format_markdown_for_html(n.message),
          data: n.data ? n.data.split("|") : [],
          reference_id: n.reference_id,
          type: n.type,
          is_unread: n.is_unread,
          timestamp: OOCTime.local_long_timestr(enactor, n.timestamp)
        }}
        
        alts = AresCentral.alts(enactor)
        alts_data = []
        alts.each do |a|
          next if a == enactor
          count = a.unread_notifications.count
          next if count == 0
          alts_data << {
            name: a.name,
            count: count
          }
        end
                
        {
          notices: notice_data,
          alts: alts_data
        }
      end
    end
  end
end