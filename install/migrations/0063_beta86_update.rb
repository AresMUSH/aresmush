module AresMUSH  

  module Migrations
    class MigrationBeta86Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Permissions."
        
        permissions = {
          "achievements" => {
            "manage_achievements" => "Award and remove achievements."
          },
          "channels" => {
            "manage_channels" => "Create and modify channels.",
            "set_comtitle" => "Can use the com title command."
          },
          "chargen" => {
            "manage_apps" => "Approve and reject character apps.",
            "view_bgs" => "Can view other characters' backgrounds"
          },
          "describe" => {
            "desc_anything" => "Edit descs on any object.",
            "desc_places" => "Edit descs on rooms and exits"
          },
          "demographics" => {
            "manage_demographics" => "Edit demographics on other players.",
          },
          "events" => {
            "manage_events" => "Edit/delete events you didn't create.",
          },
          "forum" => {
            "manage_forum" => "Create and modify forum categories and posts.",
          },
          "fs3combat" => {
            "manage_combat" => "Control combats that you didn't organize."
          },
          "fs3skills" => {
            "manage_abilities" => "Edit ability ratings on other chars.",
            "view_sheets" => "Can view other characters' sheets."
          },
          "idle" => {
            "manage_idle" => "Access idle purge commands.",
            "manage_roster" => "Access roster commands."
          },
          "jobs" => {
            "access_jobs" => "Allows non-admins to access jobs in categories allowed for their roles."
          },
          "login" => {
            "login" => "Able to log in.",
            "manage_login" => "Can access login-related admin tools like resetting someone's password."
          },
          "manage" => {
            "announce" => "Use the announce command.",
            "boot" => "Use the boot command.",
            "manage_game" => "Code and database-related tasks, including restarts and loads."
          },
          "profile" => {
            "manage_profiles" => "Allows editing other characters' profiles."
          },
          "ranks" => {
            "manage_ranks" => "Can change other characters' ranks."
          },
          "rooms" => {
            "build" => "Access build commands to create rooms and exits.",
            "go_home" => "Use the home and work commands.",
            "teleport" => "Can teleport anywhere."
          },
          "scenes" => {
            "control_npcs" => "Pose from NPCs in scenes.",
            "manage_scenes" => "Can use scene-related admin tools, like stopping or unsharing scenes."
          },
          "status" => {
            "idle_forever" => "Exempt from the idle-disconnect AFK boot.",
            "set_duty" => "Can use the on/off-duty commands."
          },
          "utils" => {
            "manage_notes" => "Can access admin-only notes."
          },
          "weather" => {
            "manage_weather" => "Can override weather conditions."
          },
          "website" => {
            "manage_theme" => "Edit web portal CSS and colors.",
            "manage_wiki" => "Create and delete restricted wiki pages."
          }
        }
        
        permissions.each do |section, values|
          if (section == "fs3skills" || section == "fs3combat")
            file = "#{section}_misc.yml"
          else
            file = "#{section}.yml"
          end
          config = DatabaseMigrator.read_config_file(file)
          config[section]["permissions"] = values
          DatabaseMigrator.write_config_file(file, config)
        end

        Global.logger.debug "Multiple plots per scene."
        Scene.all.each { |s| s.plots.replace s.plot ? [ s.plot ] : [] }
        
        Global.logger.debug "Reset system password"
        systemchar = Character.named("System")
        if (systemchar)
          Login.set_random_password(systemchar)
        end
      end
    end    
  end
end