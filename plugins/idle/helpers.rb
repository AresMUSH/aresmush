module AresMUSH
  module Idle
    def self.can_idle_sweep?(actor)
      actor && actor.has_permission?("manage_idle")
    end
    
    def self.can_manage_roster?(actor)
      actor && actor.has_permission?("manage_roster")
    end
    
    def self.roster_enabled?
      Global.read_config("idle", "use_roster")
    end
    
    def self.create_or_update_roster(client, enactor, name, contact)
      ClassTargetFinder.with_a_character(name, client, enactor) do |model|
        Idle.add_to_roster(model, contact)
        client.emit_success t('idle.roster_updated')
      end
    end
    
    def self.add_to_roster(char, contact = nil)
      char.update(roster_contact: contact || Global.read_config("idle", "default_contact"))
      char.update(idle_state: "Roster")
      char.update(roster_played: char.is_approved?)  # Assume played if approved.
      Idle.idle_cleanup(char, "Roster")
    end
    
    def self.remove_from_roster(char)
      char.update(idle_state: nil)
    end
    
    def self.is_exempt?(actor)
      actor.has_any_role?(Global.read_config("idle", "idle_exempt_roles"))
    end
    
    def self.idle_cleanup(char, idle_status)
      Global.logger.debug "Starting idle cleanup for #{char.name}"
      Login.set_random_password(char)
      if (char.handle)
        AresCentral.unlink_handle(char)
      end
      Global.dispatcher.queue_event CharIdledOutEvent.new(char.id, idle_status)
    end
    
    def self.idle_action_color(action)
    	case action
         when "Destroy"
           color = "%xh%xx"
         when "Warn"
           color = "%xh"
         when "Npc"
           color = "%xb"
         when "Dead"
           color = "%xh%xr"
         when "Gone"
           color = "%xh%xy"
         when "Roster"
           color = "%xh%xg"
         else
           color = "%xc"
       end
     end
     
     def self.roster_app_required?(char)
       return true if Global.read_config('idle', 'restrict_roster')
       return char.roster_restricted
     end
     
     def self.claim_roster(model, enactor, app_text = nil)
       enactor_name = enactor ? enactor.name : "Anonymous"
       if (!model.on_roster?)
         return { error: t('idle.not_on_roster', :name => model.name) }
       end
       
       if (Idle.roster_app_required?(model))
         if (app_text.blank?)
           return { error: t('idle.roster_app_required') }
         else
           category = Global.read_config('idle', 'roster_app_category') || "APP"
           title = t('idle.roster_app_title', :name => model.name)
           body = t('idle.roster_app_body', :target => model.name, :name => enactor_name, :app => app_text )
           Jobs.create_job(category, title, body, Game.master.system_character)
           return {}
         end
       end

       Global.logger.info("#{enactor_name} claimed #{model.name} from the roster.")
       
       password = Login.set_random_password(model)
       model.update(idle_state: nil)
       model.update(terms_of_service_acknowledged: nil)
       model.update(roster_played: true)
       
       welcome_message = Global.read_config("idle", "roster_welcome_msg")
       Mail.send_mail([model.name], t('idle.roster_welcome_msg_subject'), welcome_message, nil)          
       
       forum_category = Global.read_config("idle", "arrivals_category")
       return if !forum_category
       return if forum_category.blank?

       arrival_message = Global.read_config("idle", "roster_arrival_msg")
       arrival_message_args = Chargen.welcome_message_args(model)
       post_body = arrival_message % arrival_message_args
      
       Forum.post(forum_category, 
       t('idle.roster_post_subject'), 
       post_body, 
       Game.master.system_character)
         
       return { password: password }
     end
     
     def self.save_web_roster_fields(char, fields)
       on_roster = (fields['on_roster'] || "").to_bool
       if (on_roster)
         char.update(idle_state: "Roster")
       elsif (char.idle_state == "Roster")
         char.update(idle_state: nil)
       else
         # Don't mess with their idle state if they're not going on or coming off the roster.
       end
       
       char.update(roster_notes: Website.format_input_for_mush(fields['notes']))
       char.update(roster_contact: fields['contact'])
       char.update(roster_played: (fields['played'] || "").to_bool)
       char.update(roster_restricted: (fields['played'] || "").to_bool)
     end
     
     def self.build_idle_queue
       queue = {}
       Idle.active_chars.each do |c|
         last_on = c.last_on || Time.at(0)
         next if Idle.is_exempt?(c)
         next if c.is_npc?
         next if c.on_roster?
         idle_secs = Time.now - last_on
         idle_timeout = Global.read_config("idle", "days_before_idle")
         if (idle_secs / 86400 > idle_timeout)
           if (c.is_approved?)
             queue[c.id] = "Warn"
           else
             queue[c.id] = "Destroy"
           end
         end
       end
       queue
     end
     
     def self.execute_idle_sweep(enactor, queue)
       report = ""
       Global.logger.info "Idle sweep started by #{enactor}."
       Manage.announce t('idle.idle_sweep_beginning')
       queue.map { |id, action| action }.uniq.each do |action|
         ids =  queue.select { |id, a| a == action }
         chars = ids.map { |id, action| Character[id] }

         # Don't log destroyed chars who never hit the grid
         if (action != "Destroy")   
           title = t("idle.idle_#{action.downcase}")
           color = Idle.idle_action_color(action)
           report << "%R%r#{color}#{title}%xn"
         end
         
         chars.sort_by { |c| c.name }.each do |idle_char|

           idle_name = idle_char.name
           if (action != "Destroy")   
             report << "%R#{idle_name}"
           end
           
           case action
           when "Destroy"
             Global.logger.debug "#{idle_name} marked for termination."
             Idle.idle_cleanup(idle_char, action)
             
             Global.logger.debug "Deleting #{idle_name}"
             idle_char.delete
           when "Roster"
             Global.logger.debug "#{idle_name} added to roster."
             Idle.add_to_roster(idle_char, action)
             # Idle cleanup is done inside add to roster.
           when "Npc"
             Global.logger.debug "#{idle_name} marked as NPC."
             idle_char.update(is_npc: true)
             Idle.idle_cleanup(idle_char, action)
           when "Warn"
             Global.logger.debug "#{idle_name} idle warned."
             Mail.send_mail([idle_name], t('idle.idle_warning_subject'), Global.read_config("idle", "idle_warn_msg"), nil)          
             idle_char.update(idle_warned: true)
           else
             Global.logger.debug "#{idle_name} idle status set to: #{action}."
             idle_char.update(idle_state: action)
             Idle.idle_cleanup(idle_char, action)
           end
         end
       end
       
       Forum.system_post(
         Global.read_config("idle", "idle_category"), 
         t('idle.idle_post_subject'), 
         t('idle.idle_post_body', :report => report))
       
       Manage.announce t('idle.idle_sweep_finished')

       report
     end
  end
end