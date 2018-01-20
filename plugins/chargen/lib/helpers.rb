module AresMUSH
  module Chargen
    def self.can_approve?(actor)
      actor.has_permission?("manage_apps")
    end
    
    def self.bg_app_review(char)
      error = char.background.to_s.empty? ? t('chargen.not_set') : t('chargen.ok')
      Chargen.format_review_status t('chargen.background_review'), error
    end
    
    def self.hook_app_review(char)
      min = Global.read_config("chargen", "min_hooks")
      count = char.rp_hooks.count
      error = count < min ? t('chargen.not_enough') : t('chargen.ok')
      Chargen.format_review_status(t("chargen.hooks_added", :num => count, :min => min), error)
    end
    
    def self.set_hook(char, name, description)
      hook = char.rp_hooks.find(name: name).first
      if (hook)          
        hook.update(description: description)
      else
        RpHook.create(name: name, description: description, character: char)
      end
    end
    
    def self.can_manage_bgs?(actor)
      actor.has_permission?("can_approve")
    end     
    
    def self.can_view_bgs?(actor)
      Chargen.can_manage_bgs?(actor) || actor.has_permission?("view_bgs")
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
    
    def self.unsubmit_app(char)
      char.update(chargen_locked: false)

      job = char.approval_job
      return if !job
      
      Jobs.change_job_status(char,
        job,
        Global.read_config("chargen", "app_hold_status"),
        t('chargen.app_job_unsubmitted'))
    end
    
    def self.read_tutorial(name)
      dir = File.dirname(__FILE__) + "/../engine/templates/"
      filename = File.join(dir, name)
      File.read(filename, :encoding => "UTF-8")
    end
    
    def self.stages
      Global.read_config("chargen", "stages")
    end
    
    def self.stage_name(char)
      stage = char.chargen_stage
      stage ? Chargen.stages.keys[stage] : nil
    end 
    
    def self.save_char(char, chargen_data)
      alerts = []
      
      chargen_data[:demographics].each do |k, v|
        char.update_demographic(k, v[:value])
      end
      char.update_demographic(:fullname, chargen_data[:fullname])
      
      age = chargen_data[:demographics][:age][:value].to_i
      age_error = Demographics.check_age(age)
      if (age_error)
        alerts << age_error
      else
        bday = Date.new ICTime.ictime.year - age, ICTime.ictime.month, ICTime.ictime.day
        bday = bday - rand(364)
        char.update_demographic :birthdate, bday
      end
      
      chargen_data[:groups].each do |k, v|
        Demographics.set_group(char, k, v[:value])
      end
      
      if (Ranks.is_enabled?)
        rank_error = Ranks.set_rank(char, chargen_data[:groups][:rank][:value])
        if (rank_error)
          alerts << rank_error
        end
      end
      
      char.update(cg_background: WebHelpers.format_input_for_mush(chargen_data[:background]))
      
      Describe.update_current_desc(char, WebHelpers.format_input_for_mush(chargen_data[:desc]))
      shortdesc = chargen_data[:shortdesc]
      if (!shortdesc.blank?)
        Describe.create_or_update_desc(char, shortdesc, :short)
      end
      
      chargen_data[:fs3_attributes].each do |k, v|
        FS3Skills.set_ability(nil, char, k, v.to_i)
      end

      chargen_data[:fs3_action_skills].each do |k, v|
        FS3Skills.set_ability(nil, char, k, v.to_i)
        ability = FS3Skills.find_ability(char, k)
        specs = chargen_data[:fs3_specialties][k] || []
        ability.update(specialties: specs)
      end
      
      chargen_data[:fs3_backgrounds].each do |k, v|
        FS3Skills.set_ability(nil, char, k, v.to_i)
      end
      
      chargen_data[:fs3_languages].each do |k, v|
        FS3Skills.set_ability(nil, char, k, v.to_i)
      end
      
      return alerts
    end
       
  end
end