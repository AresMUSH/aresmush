module AresMUSH
  module Login
    class NoticesCmd
      include CommandHandler

      def handle
        
        paginator = Paginator.paginate(enactor.login_notices.to_a.sort_by { |n| [ n.is_unread ? 1 : 0, n.created_at] }.reverse, cmd.page, 20)
        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
          return
        end
        
        template = NoticesTemplate.new(enactor, paginator)
        client.emit template.render
        
        #enactor.unread_notifications.each { |n| n.update(is_unread: false)}
        
      end
    end
  end
end