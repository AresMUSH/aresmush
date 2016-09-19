$:.unshift File.dirname(__FILE__)
load "combat_interface.rb"
load "lib/0_models/combat_action.rb"
load "lib/0_models/combat_instance.rb"
load "lib/0_models/combat_model.rb"
load "lib/0_models/combatant.rb"
load "lib/0_models/damage.rb"
load "lib/0_models/vehicle.rb"
load "lib/actions/action_checkers.rb"
load "lib/actions/aim_action.rb"
load "lib/actions/attack_action.rb"
load "lib/actions/fullauto_action.rb"
load "lib/actions/pass_action.rb"
load "lib/actions/reload_action.rb"
load "lib/actions/treat_action.rb"
load "lib/combat_events.rb"
load "lib/common_checks.rb"
load "lib/damage/damage_cmd.rb"
load "lib/damage/damage_cron_handler.rb"
load "lib/damage/inflict_damage_cmd.rb"
load "lib/damage/treat_cmd.rb"
load "lib/gear/armor_detail_cmd.rb"
load "lib/gear/armor_list_cmd.rb"
load "lib/gear/combat_armor_cmd.rb"
load "lib/gear/combat_hitlocs_cmd.rb"
load "lib/gear/combat_weapon_cmd.rb"
load "lib/gear/vehicle_detail_cmd.rb"
load "lib/gear/vehicles_list_cmd.rb"
load "lib/gear/weapon_detail_cmd.rb"
load "lib/gear/weapons_list_cmd.rb"
load "lib/general/combat_action_cmd.rb"
load "lib/general/combat_ai_cmd.rb"
load "lib/general/combat_disembark_cmd.rb"
load "lib/general/combat_join_cmd.rb"
load "lib/general/combat_leave_cmd.rb"
load "lib/general/combat_list_cmd.rb"
load "lib/general/combat_luck_cmd.rb"
load "lib/general/combat_newturn_cmd.rb"
load "lib/general/combat_stance_cmd.rb"
load "lib/general/combat_start_cmd.rb"
load "lib/general/combat_stop_cmd.rb"
load "lib/general/combat_team_cmd.rb"
load "lib/general/combat_types_cmd.rb"
load "lib/general/combat_vehicle_cmd.rb"
load "lib/helpers/actions.rb"
load "lib/helpers/damage.rb"
load "lib/helpers/gear.rb"
load "lib/helpers/general.rb"
load "lib/status/combat_hud_cmd.rb"
load "lib/status/combat_npcskill_cmd.rb"
load "lib/status/combat_summary_cmd.rb"
load "templates/damage_template.rb"
load "templates/gear_template.rb"
load "templates/hud_template.rb"
load "templates/summary_template.rb"

module AresMUSH
  module FS3Combat
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("fs3combat", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/actions.md", "help/combat.md", "help/damage.md", "help/gear.md", "help/luck.md", "help/org.md" ]
    end
 
    def self.config_files
      [ "config_fs3combat.yml", "config_fs3combat_armor.yml", "config_fs3combat_damage.yml", "config_fs3combat_hitloc.yml", "config_fs3combat_vehicles.yml", "config_fs3combat_weapons.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       Global.dispatcher.temp_dispatch(client, cmd)
    end

    def self.handle_event(event)
    end
  end
end