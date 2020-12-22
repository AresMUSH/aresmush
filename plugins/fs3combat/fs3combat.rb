$:.unshift File.dirname(__FILE__)

module AresMUSH
  module FS3Combat
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("fs3combat", "shortcuts")
    end
 
    def self.achievements
      Global.read_config('fs3combat', 'achievements')
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
         when "scan"
           return HealScanCmd
         end
       when "mount"
         if (cmd.args)
           return MountDetailCmd
         else
           return MountsListCmd
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
         when "ammo"
           return CombatAmmoCmd
         when "attackmod", "defensemod", "lethalmod", "initmod"
           return CombatModCmd
         when "armor"
           return CombatArmorCmd
         when "hitloc"
           return CombatHitlocsCmd
         when "weapon"
           return CombatWeaponCmd
         when "ai"
           return CombatAiCmd
         when "disembark"
           return CombatDisembarkCmd
         when "hero"
           return CombatHeroCmd
         when "idle"
           return CombatIdleCmd
         when "join"
           return CombatJoinCmd
         when "leave"
           return CombatLeaveCmd
         when "log"
           return CombatLogCmd
         when "luck"
           return CombatLuckCmd
         when "mount"
           return CombatMountCmd
         when "dismount"
           return CombatDismountCmd
         when "npc"
           return CombatNpcCmd
         when "npcs"
           return CombatNpcsCmd
         when "newturn"
           return CombatNewTurnCmd
         when "randtarget"
           return CombatRandTargetCmd
         when "scene"
           return CombatSceneCmd
         when "skill"
           return CombatNpcSkillCmd
         when "stance"
           return CombatStanceCmd
         when "stances"
           return CombatStancesCmd
         when "start"
           return CombatStartCmd
         when "stop"
           return CombatStopCmd
         when "summary"
           return CombatSummaryCmd
         when "targets"
           return CombatTargetsCmd
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
         when "vehicles"
           return CombatVehiclesCmd
         when "unko"
           return CombatUnkoCmd
         when nil
           return CombatHudCmd
         else
           if (cmd.switch.start_with?("log"))
             return CombatLogCmd
           end
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
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "addCombatant"
        return AddCombatantRequestHandler
      when "combatant"
        return GetCombatantRequestHandler
      when "removeCombatant"
        return RemoveCombatantRequestHandler
      when "updateCombatant"
        return UpdateCombatantRequestHandler
      when "combat"
        return CombatSummaryRequestHandler
      when "combats"
        return CombatsRequestHandler
      when "combatAiActions"
        return CombatAiActionsRequestHandler
      when "combatHero"
        return CombatHeroRequestHandler
      when "combatSetup"
        return CombatSetupRequestHandler
      when "newCombatTurn"
        return NewCombatTurnRequestHandler
      when "saveCombatSetup"
        return SaveCombatSetupRequestHandler
      when "saveCombatTeams"
        return SaveCombatTeamsRequestHandler
      when "combatLog"
        return CombatLogRequestHandler
      when "gear"
        return GearListRequestHandler
      when "gearDetail"
        return GearDetailRequestHandler
      when "startCombat"
        return StartCombatRequestHandler
      when "stopCombat"
        return StopCombatRequestHandler
      end
    end
    
    def self.check_config
      validator = FS3CombatConfigValidator.new
      validator.validate
    end
  end
end
