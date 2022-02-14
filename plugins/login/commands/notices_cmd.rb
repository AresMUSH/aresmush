module AresMUSH
  module Login
    class NoticesCmd
      include CommandHandler

      attr_accessor :unread
      
      def parse_args
        self.unread = cmd.switch_is?("unread")
      end
      
      def handle
        if (self.unread)
          notices = enactor.login_notices.select { |n| n.is_unread }.sort_by { |n| n.timestamp }.reverse
        else
          notices = enactor.login_notices.to_a.sort_by { |n| [ n.is_unread ? 1 : 0, n.timestamp] }.reverse
        end
        
        paginator = Paginator.paginate(notices, cmd.page, 20)
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