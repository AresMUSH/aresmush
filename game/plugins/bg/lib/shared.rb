module AresMUSH
  module Bg
    def self.can_manage_bgs?(actor)
      return actor.has_any_role?(Global.config["bg"]["roles"]["can_manage_bgs"])
    end      
    
    def self.can_edit(actor, model, client)
      if (model.is_approved? && !Bg.can_manage_bgs?(actor))
        client.emit_failure t('bg.cannot_edit_after_approval')
        return false
      end
      
      if (actor != model && !Bg.can_manage_bgs?(actor))
        client.emit_failure t('bg.no_permission')
        return false
      end

      return true
    end
  end
end
