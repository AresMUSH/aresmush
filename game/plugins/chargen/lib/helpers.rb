module AresMUSH
  module Chargen
    def self.can_approve?(actor)
      actor.has_permission?("manage_apps")
    end
    
    def self.bg_app_review(char)
      error = char.background.to_s.empty? ? t('chargen.not_set') : t('chargen.ok')
      Chargen.format_review_status t('chargen.background_review'), error
    end
    
    def self.format_review_status(msg, error)
      "#{msg.ljust(50)} #{error}"
    end
    
    def self.can_manage_bgs?(actor)
      actor.has_permission?("can_approve")
    end     
    
    def self.can_view_bgs?(actor)
      Chargen.can_manage_bgs?(actor) || actor.has_permission?("view_bgs")
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
      dir = File.dirname(__FILE__) + "/../templates/"
      filename = File.join(dir, name)
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
    
    def self.submit_app(char)
      info = char.get_or_create_chargen_info
      job = info.approval_job
      
      if (!job)
        result = Jobs::Api.create_job(Global.read_config("chargen", "jobs", "app_category"), 
          t('chargen.application_title', :name => char.name), 
          t('chargen.app_job_submitted'), 
          char)
      
        if (result[:error])
          raise "Problem submitting application: #{job[:error]}"
        end
        job = result[:job]
        info.update(locked: true)
        info.update(approval_job: job)
        return t('chargen.app_submitted')
      else
        info.update(locked: true)
        Jobs::Api.change_job_status(char,
          job,
          Global.read_config("chargen", "jobs", "app_resubmit_status"),
          t('chargen.app_job_resubmitted'))
        return t('chargen.app_resubmitted')
      end
    end
    
    
  end
end