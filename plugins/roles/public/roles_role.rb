module AresMUSH
  class Role
    
    before_delete :notify_role_deleted

    def notify_role_deleted
  
      Character.all.each do |c|
        if (c.roles.include?(self))
          c.roles.delete self
        end
      end
  
      Global.dispatcher.queue_event RoleDeletedEvent.new(self.id)
    end
    
  end
end