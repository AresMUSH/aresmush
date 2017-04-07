$:.unshift File.dirname(__FILE__)

# Models must come first
load "lib/models/combat_log.rb"
load "lib/models/combat_instance.rb"
load "lib/models/combat_model.rb"
load "lib/models/combatant.rb"
load "lib/models/damage.rb"
load "lib/models/vehicle.rb"
load "lib/models/healing.rb"
load "lib/models/npc.rb"

load "fs3combat_api.rb"
load "lib/actions/combat_action.rb"
load "lib/actions/combatant_helper.rb"
load "lib/actions/actions_helper.rb"
load "lib/actions/aim_action.rb"
load "lib/actions/attack_action.rb"
load "lib/actions/escape_action.rb"
load "lib/actions/explode_action.rb"
load "lib/actions/fullauto_action.rb"
load "lib/actions/pass_action.rb"
load "lib/actions/rally_action.rb"
load "lib/actions/subdue_action.rb"
load "lib/actions/suppress_action.rb"
load "lib/actions/reload_action.rb"
load "lib/actions/treat_action.rb"
load "lib/common_checks.rb"
load "lib/damage/damage_cmd.rb"
load "lib/damage/damage_cron_handler.rb"
load "lib/damage/damage_helper.rb"
load "lib/damage/heal_start_cmd.rb"
load "lib/damage/heal_stop_cmd.rb"
load "lib/damage/healing_cmd.rb"
load "lib/damage/hospitals_cmd.rb"
load "lib/damage/hospital_set_cmd.rb"
load "lib/damage/delete_damage_cmd.rb"
load "lib/damage/inflict_damage_cmd.rb"
load "lib/damage/modify_damage_cmd.rb"
load "lib/damage/treat_cmd.rb"
load "lib/gear/armor_detail_cmd.rb"
load "lib/gear/armor_list_cmd.rb"
load "lib/gear/combat_armor_cmd.rb"
load "lib/gear/combat_hitlocs_cmd.rb"
load "lib/gear/combat_weapon_cmd.rb"
load "lib/gear/gear_helper.rb"
load "lib/gear/vehicle_detail_cmd.rb"
load "lib/gear/vehicles_list_cmd.rb"
load "lib/gear/weapon_detail_cmd.rb"
load "lib/gear/weapons_list_cmd.rb"
load "lib/general/combat_action_cmd.rb"
load "lib/general/combat_ai_cmd.rb"
load "lib/general/combat_luck_cmd.rb"
load "lib/general/combat_mod_cmd.rb"
load "lib/general/combat_newturn_cmd.rb"
load "lib/general/combat_randtarget_cmd.rb"
load "lib/general/combat_stance_cmd.rb"
load "lib/general/combat_team_cmd.rb"
load "lib/general/combat_transfer_cmd.rb"
load "lib/general/combat_types_cmd.rb"
load "lib/general/general_helper.rb"
load "lib/general/combat_hero_cmd.rb"
load "lib/general/combat_target_cmd.rb"
load "lib/general/combat_unko_cmd.rb"
load "lib/general/combat_npc_cmd.rb"
load "lib/joining/combat_join_cmd.rb"
load "lib/joining/combat_leave_cmd.rb"
load "lib/joining/combat_list_cmd.rb"
load "lib/joining/combat_start_cmd.rb"
load "lib/joining/combat_stop_cmd.rb"
load "lib/joining/joining_helper.rb"
load "lib/pose_handler.rb"
load "lib/status/combat_hud_cmd.rb"
load "lib/status/combat_summary_cmd.rb"
load "lib/status/combat_log_cmd.rb"
load "lib/vehicles/combat_disembark_cmd.rb"
load "lib/vehicles/combat_vehicle_cmd.rb"
load "lib/vehicles/vehicles_helper.rb"
load "templates/damage_template.rb"
load "templates/gear_detail_template.rb"
load "templates/gear_list_template.rb"
load "templates/healing_template.rb"
load "templates/hud_template.rb"
load "templates/summary_template.rb"
load "templates/types_template.rb"


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
      [ "help/actions.md", "help/combat.md", "help/damage.md", "help/gear.md", "help/luck.md", 
        "help/org.md", "help/hospitals.md" ]
    end
 
    def self.config_files
      [ "config_fs3combat.yml", "config_fs3combat_armor.yml", "config_fs3combat_damage.yml", 
        "config_fs3combat_hitloc.yml", "config_fs3combat_vehicles.yml", "config_fs3combat_weapons.yml",
        "config_fs3combat_npcs.yml", "config_fs3combat_skills.yml" 
      ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when"damage"
         case cmd.switch
         when "inflict"
           return InflictDamageCmd
         when "modify"
           return ModifyDamageCmd
         when "delete"
           return DeleteDamageCmd
         when nil
           return DamageCmd
         end
       when "treat"
         return TreatCmd
       when "armor"
         if (cmd.args)
           return ArmorDetailCmd
         else
           return ArmorListCmd
         end
       when "heal"
         case cmd.switch
         when "start", nil
           return HealStartCmd
         when "stop"
           return HealStopCmd
         when "list"
           return HealingCmd
         end
       when "hospital"
         case cmd.switch
         when "list"
           return HospitalsCmd
         when "on", "off"
           return HospitalSetCmd
         end
       when "vehicle"
         if (cmd.args)
           return VehicleDetailCmd
         else
           return VehiclesListCmd
         end
       when "weapon"
         if (cmd.args)
           return WeaponDetailCmd
         else
           return WeaponsListCmd
         end
       when "combats"
         return CombatListCmd
       when "combat"
         case cmd.switch
         when "all", "list"
           return CombatListCmd
         when "attackmod", "defensemod", "lethalmod"
           return CombatModCmd
         when "armor"
           return CombatArmorCmd
         when "hitlocs"
           return CombatHitlocsCmd
         when "weapon"
           return CombatWeaponCmd
         when "ai"
           return CombatAiCmd
         when "disembark"
           return CombatDisembarkCmd
         when "hero"
           return CombatHeroCmd
         when "join"
           return CombatJoinCmd
         when "leave"
           return CombatLeaveCmd
         when "log"
           return CombatLogCmd
         when "luck"
           return CombatLuckCmd
         when "npc"
           return CombatNpcCmd
         when "newturn"
           return CombatNewTurnCmd
         when "randtarget"
           return CombatRandTargetCmd
         when "skill"
           return CombatNpcSkillCmd
         when "stance"
           return CombatStanceCmd
         when "start"
           return CombatStartCmd
         when "stop"
           return CombatStopCmd
         when "summary"
           return CombatSummaryCmd
         when "target"
           return CombatTargetCmd
         when "team"
           return CombatTeamCmd
         when "transfer"
           return CombatTransferCmd
         when "types"
           return CombatTypesCmd
         when "pilot", "passenger"
           return CombatVehicleCmd
         when "unko"
           return CombatUnkoCmd
         when nil
           return CombatHudCmd
         else
           return CombatActionCmd
         end
       end
       
       nil
    end

    def self.get_event_handler(event_name)
      case event_name
      when "PoseEvent"
        return PoseEventHandler
      when "CronEvent"
        return DamageCronHandler
      end
      nil
    end
  end
end