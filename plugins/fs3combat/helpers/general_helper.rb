module AresMUSH
  module FS3Combat
    
    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("fs3combat")
    end
    
    def self.can_manage_combat?(actor, combat)
      return false if !actor
      return true if combat.organizer == actor
      actor.has_permission?("manage_combat")
    end
    
    def self.combats
      Combat.all.sort { |c| c.num }.reverse
    end
    
    def self.combat_for_scene(scene)
      Combat.all.select { |c| c.scene == scene }.first
    end
    
    def self.combatant_types
      Global.read_config("fs3combat", "combatant_types")
    end
    
    def self.stances
      Global.read_config("fs3combat", "stances")
    end
    
    def self.default_combatant_type
      Global.read_config("fs3combat", "default_type")
    end
    
    def self.vehicles_allowed?
      Global.read_config("fs3combat", "allow_vehicles")
    end
    
    def self.mounts_allowed?
      Global.read_config("fs3combat", "allow_mounts")
    end
      
    def self.passenger_types
      [ "Pilot", "Passenger" ]
    end
    
    def self.is_in_combat?(name)
      !!FS3Combat.combat(name)
    end
    
    def self.combat(name)
      FS3Combat.combats.select { |c| c.has_combatant?(name) }.first
    end
    

    def self.emit_to_combat(combat, message, npcmaster = nil, scene_pose = false, filter_for_screenreader = false)
      message = message + "#{npcmaster}"
      combat.log(message)

      if (combat.scene && !combat.scene.completed)
        if (scene_pose)
          Scenes.add_to_scene(combat.scene, message)
        else
          Scenes.add_to_scene(combat.scene, message, Game.master.system_character, false, true)
        end
      end
      
      web_msg = "#{combat.id}|#{Website.format_markdown_for_html(message)}"
       Global.client_monitor.notify_web_clients(:combat_activity, web_msg, true) do |c|
         c && c.combatant && c.combatant.combat == combat
      end

      combat.combatants.each do |combatant|
        FS3Combat.emit_to_combatant(combatant, message, filter_for_screenreader)
      end
    end
      
    def self.emit_to_organizer(combat, message, npcmaster = nil)
      message = message + " (#{npcmaster})" if npcmaster
        
      client = Login.find_client(combat.organizer)
      if (client)
        client.emit t('fs3combat.organizer_emit', :message => message)
      end
    end
    
    def self.emit_to_combatant(combatant, message, filter_for_screenreader = false)
      char = combatant.character
      return if !char
      
      client = Login.find_client(char)
      if (client)
        client_message = message.gsub(/#{combatant.name}/, "%xh%xc#{combatant.name}%xn")  
        client_message.split("\n").each do |part|
          next if filter_for_screenreader && client.screen_reader && part !~ /#{combatant.name}/
          client.emit t('fs3combat.combat_emit', :message => part)
        end
      end
    end
    
    def self.combatant_type_stat(type, stat)
      type_config = FS3Combat.combatant_types[type]
      type_config[stat]
    end
    
    def self.npc_type(name)
      types = Global.read_config("fs3combat", "npc_types")
      types.select { |k, v| k.upcase == name.upcase}.values.first || {}
    end
    
    def self.npc_type_names
      Global.read_config("fs3combat", "npc_types").keys.map { |n| n.titlecase }
    end
    
    def self.default_npc_type
      Global.read_config('fs3combat', 'default_npc_type') || 'Goon'
    end
    
    # Finds a character, vehicle or NPC by name
    def self.find_named_thing(name, enactor)
      result = ClassTargetFinder.find(name, Character, enactor)
      if (result.found?)
        return result.target
      end
      
      combatant = enactor.combatant
      if (!combatant)
        return nil
      end
      
      return combatant.combat.find_named_thing(name)
    end
    
    def self.get_initiative_order(combat)
      ability = Global.read_config("fs3combat", "initiative_skill")
      order = []
      combat.active_combatants.each do |c|
        roll = FS3Combat.roll_initiative(c, ability)
        order << { :combatant => c.id, :name => c.name, :roll => roll }
      end
      combat.log "Combat initiative rolls: #{order.map { |o| "#{o[:name]}=#{o[:roll]}" }}"
      order.sort_by { |c| [c[:roll], rand(10)] }.map { |c| c[:combatant] }.reverse
    end
    
    def self.with_a_combatant(name, client, enactor, &block)      
      if (!enactor.is_in_combat?)
        client.emit_failure t('fs3combat.you_are_not_in_combat')
        return
      end
      
      combat = enactor.combat
      combatant = combat.find_combatant(name)
      
      if (!combatant)
        client.emit_failure t('fs3combat.not_in_combat', :name => name)
        return
      end
      
      yield combat, combatant
    end
    
    def self.npcmaster_text(name, actor)
      return nil if !actor
      actor.name == name ? nil : t('fs3combat.npcmaster_text', :name => actor.name)
    end
    
    def self.new_turn(enactor, combat)
      combat.log "****** NEW COMBAT TURN ******"

      if (combat.first_turn)
        combat.active_combatants.select { |c| c.is_npc? && !c.action }.each_with_index do |c, i|
          FS3Combat.ai_action(combat, c)
        end
        FS3Combat.emit_to_combat combat, t('fs3combat.new_turn', :name => enactor.name)
        combat.update(first_turn: false)
        return
      end
      
      FS3Combat.emit_to_combat combat, t('fs3combat.starting_turn_resolution', :name => enactor.name)
      combat.update(turn_in_progress: true)
      combat.update(everyone_posed: false)

      Global.dispatcher.spawn("Combat Turn", nil) do
        begin
          initiative_order = FS3Combat.get_initiative_order(combat)
          
          all_messages = []
          
          initiative_order.each do |id|
            c = Combatant[id]
            next if !c.action
            next if c.is_noncombatant?

            combat.log "Action #{c.name} #{c.action ? c.action.print_action_short : "-"} #{c.is_noncombatant?}"
            
            messages = c.action.resolve   
            all_messages.concat messages         
          end
      
          FS3Combat.emit_to_combat combat, all_messages.join("\n"), nil, true, true

          combat.log "---- Resolutions ----"
          combat.active_combatants.each { |c| FS3Combat.reset_for_new_turn(c) }
          # This will reset their action if it's no longer valid.  Do this after everyone's been KO'd.
          combat.active_combatants.each { |c| c.action }
    
          FS3Combat.emit_to_combat combat, t('fs3combat.new_turn', :name => enactor.name)
          
          combat_data = FS3Combat.build_combat_web_data(combat, nil)
          
          web_msg = "#{combat.id}|#{combat_data[:teams].to_json}"
           Global.client_monitor.notify_web_clients(:new_combat_turn, web_msg, true) do |c|
             c && c.combatant && c.combatant.combat == combat
          end
          
        rescue Exception => ex
          Global.logger.error "Error in combat turn: #{ex} #{ex.backtrace[0,10]}"
        ensure
          combat.update(turn_in_progress: false)
        end
      end
    end
    
    def self.build_combat_web_data(combat, viewer)
      can_manage = FS3Combat.can_manage_combat?(viewer, combat)
      
      teams = combat.active_combatants.sort_by { |c| c.team }
        .group_by { |c| c.team }
        .map { |team, members| 
          { 
            team: team,
            combatants: members.map { |c| 
              FS3Combat.build_combatant_summary_data(combat, c, viewer)
            }
          }
        }
      
      viewer_in_combat = viewer && viewer.combat == combat
      
      {
        id: combat.id,
        combatant_id: viewer_in_combat ? viewer.combatant.id : nil,
        organizer: combat.organizer.name,
        can_manage: can_manage,
        combatant_types: FS3Combat.combatant_types.keys,
        teams: teams,
        in_combat: viewer_in_combat,
        luck_points: viewer ? viewer.fs3_luck.floor : 0
      }
    end
    
    def self.build_combatant_summary_data(combat, combatant, viewer)
      can_manage = FS3Combat.can_manage_combat?(viewer, combat)

      {
        id: combatant.id,
        name: combatant.name,
        is_ko: combatant.is_ko,
        weapon: combatant.weapon,
        armor: combatant.armor,
        is_npc: combatant.is_npc?,
        team: combatant.team,
        ammo: combatant.ammo ? "(#{combatant.ammo})" : '',
        damage_boxes: ([-combatant.total_damage_mod.floor, 5].min).times.map { |d| d },
        wound_display: combatant.associated_model.damage.map { |d| "#{d.current_severity} #{d.description}"}.join("\n"),
        damage: combatant.associated_model.damage.select { |d| !d.healed }.map { |d| "#{d.current_severity} - #{d.description}" },
        vehicle: combatant.vehicle ? "#{combatant.vehicle.name} #{combatant.piloting ? 'Pilot' : 'Passenger'}" : "" ,
        stance: combatant.stance,
        action: combatant.action ? combatant.action.print_action_short : "",
        can_edit: can_manage || (viewer && viewer.name == combatant.name)
      }
    end
  end
end