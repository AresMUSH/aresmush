module AresMUSH
  module Chargen
    def self.can_approve?(actor)
      actor.has_any_role?(Global.read_config("chargen", "roles", "can_approve"))
    end
    
    def self.bg_app_review(char)
      error = char.background.nil? ? t('chargen.not_set') : t('chargen.ok')
      chargen.format_review_status t('chargen.background_review'), error
    end
    
    def self.can_manage_bgs?(actor)
      return actor.has_any_role?(Global.read_config("chargen", "roles", "can_manage_bgs"))
    end     
    
    def self.can_view_bgs?(actor)
      return actor.has_any_role?(Global.read_config("chargen", "roles", "can_view_bgs"))
    end      
    
    def self.approval_status(char)
      if (Roster::Interface.on_roster?(char))
        status = "%xb%xh#{t('chargen.rostered')}%xn"
      elsif (Idle::Interface.idled_status(char))
        status = "%xr%xh#{t('chargen.idled_out', :status => Idle::Interfaces.idled_status(char))}%xn"
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
    
    def self.show_bg(model, client)
      template = BgTemplate.new(model, client)
      template.render
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
      
    def self.chargen_display(char)
      stage_index = char.chargen_stage
      display = ""
      
      prev_page_footer = (stage_index == 0 ? "" : t('chargen.prev_page_footer')).ljust(39)
      next_page_footer = (stage_index >= Chargen.stages.keys.count - 1 ? "" : t('chargen.next_page_footer')).rjust(39)
      
      begin
        stage = Chargen.stages[Chargen.stage_name(char)]
        tutorial_file = stage["tutorial"]
        help_file = stage["help"]
      
        if (tutorial_file)
          display << Chargen.read_tutorial(tutorial_file)
        end
        if (tutorial_file && help_file)
          display << "%R%l2%R"
        end        
        if (help_file)
          display << Help::Interface.get_help(help_file)
        end
        display << "%R%L2%R#{prev_page_footer}#{next_page_footer}"
      rescue Exception => e
        error_msg = "Error loading chargen tutorial stage #{stage}"
        Global.logger.error "#{error_msg}: #{e}"
        Global.dispatcher.queue_event UnhandledErrorEvent.new(error_msg)
        display << t('chargen.error_loading_tutorial')
      end
      
      display
    end
  end
end