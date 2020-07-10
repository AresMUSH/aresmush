module AresMUSH
  module Idle
    def self.can_idle_sweep?(actor)
      actor.has_permission?("manage_idle")
    end
    
    def self.can_manage_roster?(actor)
      actor.has_permission?("manage_roster")
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
  end
end