module AresMUSH
  module Idle
    def self.active_chars
      Character.all.select { |c| c.is_active? }
    end
  
    def self.build_web_profile_data(char, viewer)
      if (char.on_roster?)
        roster_info = {
          notes: char.roster_notes ? Website.format_markdown_for_html(char.roster_notes) : nil,
          previously_played: char.roster_played,
          app_required: Idle.roster_app_required?(char),
          contact: char.roster_contact,
          app_template: Website.format_input_for_html(Global.read_config("idle", "roster_app_template") || "")
        }
      else
        roster_info = nil
      end
      
      {
        roster: roster_info,
        idle_notes: char.idle_notes ? Website.format_markdown_for_html(char.idle_notes) : nil,
      }
    end
    
    def self.build_web_profile_edit_data(char, viewer, is_profile_manager)
      roster_manager = Idle.can_manage_roster?(viewer)
      idle_manager = Idle.can_idle_sweep?(viewer)
      {
        roster: {
          on_roster: char.on_roster?,
          notes: Website.format_input_for_html(char.roster_notes),
          contact: char.roster_contact,
          played: char.roster_played,
          restricted: char.roster_restricted
        },
        idle_notes: Website.format_input_for_html(char.idle_notes),
        lastwill: Website.format_input_for_html(char.idle_lastwill),
        show_roster_tab: roster_manager,
        show_idle_tab: idle_manager
      }
    end
  end
end