module AresMUSH
  module Login
    class NoticesCatchupCmd
      include CommandHandler

      def handle
        
        enactor.unread_notifications.each { |n| n.update(is_unread: false)}
        client.emit_success t('login.notices_caught_up')
      end
    end
  end
end