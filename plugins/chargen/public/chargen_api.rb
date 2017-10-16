module AresMUSH
  module Chargen
    def self.format_review_status(msg, error)
      "#{msg.ljust(50)} #{error}"
    end
    
    def self.check_chargen_locked(char)
      return t('chargen.cant_be_changed') if char.is_approved?
      return t('chargen.app_in_progress') if char.chargen_locked
      return nil
    end
    
    def self.is_in_stage?(char, stage_name)
      Chargen.stage_name(char) == stage_name
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
    
      
    def self.approval_job_notice(char)
      char.approval_job ? t('chargen.approval_reminder') : nil
    end
    
    def self.submit_app(char)
      job = char.approval_job
      
      if (!job)
        result = Jobs.create_job(Global.read_config("chargen", "jobs", "app_category"), 
          t('chargen.application_title', :name => char.name), 
          t('chargen.app_job_submitted'), 
          char)
      
        if (result[:error])
          raise "Problem submitting application: #{job[:error]}"
        end
        job = result[:job]
        char.update(chargen_locked: true)
        char.update(approval_job: job)
        return t('chargen.app_submitted')
      else
        char.update(chargen_locked: true)
        Jobs.change_job_status(char,
          job,
          Global.read_config("chargen", "jobs", "app_resubmit_status"),
          t('chargen.app_job_resubmitted'))
        return t('chargen.app_resubmitted')
      end
    end    
      
    def self.approved_chars
      Idle.active_chars.select { |c| c.is_approved? }
    end
  end
end