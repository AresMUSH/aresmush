module AresMUSH
  module Chargen
    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("chargen")
    end
    
    def self.format_review_status(msg, error)
      "#{msg.ljust(50)} #{error}"
    end
    
    def self.is_chargen_locked?(char)
      char.is_approved? || char.chargen_locked
    end
    
    def self.check_chargen_locked(target)
      # Note: Most of these commands work on enactor-only, so we allow admins to change whatever they want
      # on themselves. The commands that allow other players separately check whether to allow admins to override
      # the lock.
      return nil if target.is_admin?
      return t('chargen.cant_be_changed') if target.is_approved?
      return t('chargen.app_in_progress') if target.chargen_locked
      return nil
    end
    
    def self.is_in_stage?(char, stage_name)
      Chargen.stage_name(char) == stage_name
    end
    
    def self.hook_app_review(char)
      if !Global.read_config('chargen', 'hooks_required')
        return ""
      end
        
      message = t('chargen.hook_review')
      status = char.rp_hooks.blank? ?  t('chargen.not_set') : t('chargen.ok')
      
      Chargen.format_review_status(message, status)
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
      return nil if char.is_approved?
      char.approval_job ? t('chargen.approval_reminder') : nil
    end
    
    def self.submit_app(char, app_notes = nil)
      job = char.approval_job
      
      app_notes = app_notes || t('global.none')
      
      if (!job)
        result = Jobs.create_job(Global.read_config("chargen", "app_category"), 
          t('chargen.application_title', :name => char.name), 
          t('chargen.app_job_submitted', :notes => app_notes), 
          char)
      
        if (result[:error])
          raise "Problem submitting application: #{job[:error]}"
        end
        job = result[:job]
        char.update(chargen_locked: true)
        char.update(approval_job: job)
        
        return t('chargen.app_submitted', :notes => app_notes)
      else
        char.update(chargen_locked: true)
        Jobs.change_job_status(char,
          job,
          Global.read_config("chargen", "app_resubmit_status"),
          t('chargen.app_job_resubmitted', :notes => app_notes))
          
        return t('chargen.app_resubmitted')
      end
    end    
      
    def self.approved_chars
      Idle.active_chars.select { |c| c.is_approved? }
    end
    
    def self.welcome_message_args(model)
      args = { 
        name: model.name, 
        rp_hooks: model.rp_hooks || t('global.none'),
        profile_link: "#{Game.web_portal_url}/char/#{model.name}",
        position: '',
        faction: '' }
      
      Demographics.all_groups.keys.each do |k|
        args[k.downcase.to_sym] = model.group(k)
      end
      
      args
    end
  end
end