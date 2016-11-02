module AresMUSH
  module Chargen
    def self.can_approve?(actor)
      actor.has_any_role?(Global.read_config("chargen", "roles", "can_approve"))
    end
    
    def self.bg_app_review(char)
      error = !char.background ? t('chargen.not_set') : t('chargen.ok')
      Chargen.format_review_status t('chargen.background_review'), error
    end
    
    def self.format_review_status(msg, error)
      "#{msg.ljust(50)} #{error}"
    end
    
    def self.can_manage_bgs?(actor)
      return actor.has_any_role?(Global.read_config("chargen", "roles", "can_manage_bgs"))
    end     
    
    def self.can_view_bgs?(actor)
      return actor.has_any_role?(Global.read_config("chargen", "roles", "can_view_bgs"))
    end      
    
    def self.approval_status(char)
      if (char.on_roster?)
        status = "%xb%xh#{t('chargen.rostered')}%xn"
      elsif (char.is_npc?)
        status = "%xb%xh#{t('chargen.npc')}%xn"
      elsif (char.idled_out?)
        status = "%xr%xh#{t('chargen.idled_out', :status => char.idled_out_reason)}%xn"
      elsif (!char.is_approved?)
        status = "%xr%xh#{t('chargen.unapproved')}%xn"
      else
        status = "%xg%xh#{t('chargen.approved')}%xn"
      end        
      status
    end
    
    def self.check_chargen_locked(char)
      return t('chargen.cant_be_changed') if char.is_approved?

      info = char.chargen_info
      return nil if !info
      return t('chargen.app_in_progress') if info.locked
      return nil
    end
    
    def self.is_in_stage?(char, stage_name)
      Chargen.stage_name(char) == stage_name
    end
    
    def self.can_edit_bg?(actor, model, client)
      if (model.is_approved? && !Chargen.can_manage_bgs?(actor))
        client.emit_failure t('chargen.cannot_edit_after_approval')
        return false
      end
      
      if (actor != model && !Chargen.can_manage_bgs?(actor))
        client.emit_failure t('chargen.cannot_edit_bg')
        return false
      end

      return true
    end
    
    def self.read_tutorial(name)
      dir = File.dirname(__FILE__) + "/../tutorial/"
      filename = File.join(dir, Global.locale.locale.to_s, name)
      File.read(filename, :encoding => "UTF-8")
    end
    
    def self.stages
      Global.read_config("chargen", "stages")
    end
    
    def self.stage_name(char)
      stage = Chargen.current_stage(char)
      stage ? Chargen.stages.keys[stage] : nil
    end
    
    def self.current_stage(char)
      char.chargen_info ? char.chargen_info.current_stage : nil
    end
    
    def self.approval_job(char)
      char.chargen_info ? char.chargen_info.approval_job : nil
    end
  end
end