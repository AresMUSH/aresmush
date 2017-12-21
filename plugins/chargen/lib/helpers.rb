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
  end
end