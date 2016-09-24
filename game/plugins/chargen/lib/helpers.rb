module AresMUSH
  module Chargen
    def self.can_approve?(actor)
      actor.has_any_role?(Global.read_config("chargen", "roles", "can_approve"))
    end
    
    def self.bg_app_review(char)
      error = char.background.nil? ? t('chargen.not_set') : t('chargen.ok')
      Chargen.format_review_status t('chargen.background_review'), error
    end
    
    def self.can_manage_bgs?(actor)
      return actor.has_any_role?(Global.read_config("chargen", "roles", "can_manage_bgs"))
    end     
    
    def self.can_view_bgs?(actor)
      return actor.has_any_role?(Global.read_config("chargen", "roles", "can_view_bgs"))
    end      
    
    def self.approval_status(char)
      if (Roster::Api.on_roster?(char))
        status = "%xb%xh#{t('chargen.rostered')}%xn"
      elsif (Idle::Api.idled_status(char))
        status = "%xr%xh#{t('chargen.idled_out', :status => Idle::Apis.idled_status(char))}%xn"
      elsif (!char.is_approved?)
        status = "%xr%xh#{t('chargen.unapproved')}%xn"
      else
        status = "%xg%xh#{t('chargen.approved')}%xn"
      end        
      status
    end
    
    def self.check_chargen_locked(char)
      hold_status = Global.read_config("chargen", "jobs", "app_hold_status")
      return t('chargen.cant_be_changed') if char.is_approved
      return t('chargen.app_in_progress') if char.chargen_locked
      return nil
    end
    
    def self.is_in_stage?(char, stage_name)
      name = Chargen.stage_name(char)
      name == stage_name
    end
    
    def self.format_review_status(msg, error)
      "#{msg.ljust(50)} #{error}"
    end
    
    def self.can_edit_bg?(actor, model, client)
      if (model.is_approved && !Chargen.can_manage_bgs?(actor))
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
      Chargen.stages.keys[char.chargen_stage]
    end
  end
end