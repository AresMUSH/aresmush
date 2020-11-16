module AresMUSH
  module Scenes

    def self.build_scene_pose_web_data(pose, viewer, live_update = false)
      {
        char: { name: pose.character ? pose.character.name : t('global.deleted_character'), 
                nick: pose.character ? pose.character.nick : t('global.deleted_character'), 
                icon: Website.icon_for_char(pose.character),
                id: pose.character ? pose.character.id : 0 }, 
        order: pose.order, 
        id: pose.id,
        timestamp: OOCTime.local_short_date_and_time(viewer, pose.created_at),
        is_setpose: pose.is_setpose,
        is_system_pose: pose.is_system_pose?,
        restarted_scene_pose: pose.restarted_scene_pose,
        place_name: pose.place_name,
        is_ooc: pose.is_ooc,
        raw_pose: pose.pose,
        can_edit: pose.can_edit?(viewer),
        can_delete: pose.restarted_scene_pose ? false : pose.can_edit?(viewer),
        pose: Website.format_markdown_for_html(pose.pose),
        live_update: live_update
      }
    end
    
    def self.build_live_scene_web_data(scene, viewer)
      participants = Scenes.participants_and_room_chars(scene)
          .sort_by {|p| p.name }
          .map { |p| { 
            name: p.name, 
            nick: p.nick,
            id: p.id, 
            icon: Website.icon_for_char(p), 
            status: Website.activity_status(p),
            is_ooc: p.is_admin? || p.is_playerbit?,
            online: Login.is_online?(p),
            char_card: Scenes.build_char_card_web_data(p, viewer)
            }}
      
      if (scene.room)
        places = scene.room.places.to_a.sort_by { |p| p.name }.map { |p| {
          name: p.name,
          chars: p.characters.map { |c| {
            name: c.name,
            icon: Website.icon_for_char(c)
          }}
        }}
      else
        places = nil
      end
         
      combat = FS3Combat.is_enabled? ? FS3Combat.combat_for_scene(scene) : nil
      
      {
        id: scene.id,
        title: scene.title,
        location: Scenes.build_location_web_data(scene),
        completed: scene.completed,
        summary: Website.format_markdown_for_html(scene.summary),
        content_warning: scene.content_warning,
        tags: scene.tags,
        icdate: scene.icdate,
        is_private: scene.private_scene,
        participants: participants,
        scene_type: scene.scene_type ? scene.scene_type.titlecase : 'unknown',
        scene_pacing: scene.scene_pacing,
        can_edit: viewer && Scenes.can_edit_scene?(viewer, scene),
        can_delete: Scenes.can_delete_scene?(viewer, scene),
        is_watching: viewer && scene.watchers.include?(viewer),
        is_unread: viewer && scene.is_unread?(viewer),
        pose_order: Scenes.build_pose_order_web_data(scene),
        combat: combat ? combat.id : nil,
        places: places,
        poses: scene.poses_in_order.map { |p| Scenes.build_scene_pose_web_data(p, viewer) },
        fs3_enabled: FS3Skills.is_enabled?,
        fs3combat_enabled: FS3Combat.is_enabled?,
        poseable_chars: Scenes.build_poseable_chars_data(scene, viewer),
        pose_order_type: scene.room ? scene.room.pose_order_type : nil,
        use_custom_char_cards: Scenes.use_custom_char_cards?,
        extras_installed: Global.read_config('plugins', 'extras') || [],
        limit: scene.limit
      }
    end    
    
    def self.build_scene_summary_web_data(scene)
      {
        id: scene.id,
        title: scene.title,
        summary: Website.format_markdown_for_html(scene.summary),
        content_warning: scene.content_warning,
        date_shared: scene.date_shared,
        location: scene.location,
        icdate: scene.icdate,
        likes: scene.likes,
        participants: scene.participants.to_a.sort_by { |p| p.name }.map { |p| 
          { name: p.name, nick: p.nick, id: p.id, icon: Website.icon_for_char(p) }},
        scene_type: scene.scene_type ? scene.scene_type.titlecase : 'Unknown',
        scene_pacing: scene.scene_pacing,
        limit: scene.limit
        }
      end
    
    def self.build_location_web_data(scene)
      {
        name: scene.location,
        description: scene.room ? Website.format_markdown_for_html(scene.room.expanded_desc) : nil,
        scene_set: scene.room ? Website.format_markdown_for_html(scene.room.scene_set) : nil,
        details: scene.room ? scene.room.details.map { |k, v| { name: k, desc: Website.format_markdown_for_html(v) } } : []
      }
    end
    
    def self.build_pose_order_web_data(scene)
      return {} if !scene.room
      scene.room.sorted_pose_order.map { |name, time| 
        {
         name: name,
         time: Time.parse(time).rfc2822
         }}
    end
    
    def self.build_poseable_chars_data(scene, enactor)
      return [] if !enactor
      pose_chars = scene.participants
         .select { |p| Scenes.can_pose_char?(enactor, p) }
      
      pose_chars << enactor
         
      pose_chars.uniq
         .sort_by { |p| [ p == enactor ? 0 : 1, p.name ]}
         .map { |p| { id: p.id, name: p.name, icon: Website.icon_for_char(p) }}   
    end
    

    def self.parse_web_pose(pose, enactor, pose_type)
      is_setpose = pose_type == 'setpose'
      is_gmpose = pose_type == 'gm'
      is_ooc = pose_type == 'ooc'
      
      if (pose.start_with?("/"))
        return {
          command: pose.after("/").before(" "),
          args: pose.after(" ")
        }
      end
      
      command = ((pose.split(" ").first) || "").downcase
      is_emit = false
      
      if (command == "ooc")
        is_ooc = true
        is_gmpose = false
        is_setpose = false
        pose = pose.after(" ")
        pose = PoseFormatter.format(enactor.name, pose)
      elsif (command == "scene/set")
        is_setpose = true
        is_emit = true
        pose = pose.after(" ")
      elsif (command == "emit/set") 
        is_setpose = true
        is_emit = true
        pose = pose.after(" ")
      elsif (command == "emit/gm")
        is_gmpose = true
        is_emit = true
        pose = pose.after(" ")
      elsif (command == "emit")
        is_emit = true
        pose = pose.after(" ")
      else
        markers = PoseFormatter.pose_markers
        markers.delete "\""
        markers.delete "'"
        if (pose.start_with?(*markers) || is_ooc)
          pose = PoseFormatter.format(enactor.name, pose)
        else 
          is_emit = true
        end
      end
      
      {
        pose: pose,
        is_emit: is_emit,
        is_ooc: is_ooc,
        is_setpose: is_setpose,
        is_gmpose: is_gmpose
      }
    end
    
    def self.use_custom_char_cards?
      Global.read_config("scenes", "use_custom_char_cards") || false
    end
    
    def self.build_char_card_web_data(char, viewer)
      if (!char)
        return {
          name: t('global.deleted_character'),
          icon: Website.icon_for_char(char),
          id: nil
        }
      end
      
      {
        name: char.name,
        icon: Website.icon_for_char(char),
        id: char.id,
        all_fields: Demographics.build_web_all_fields_data(char, viewer),
        demographics: Demographics.build_web_demographics_data(char, viewer),
        groups: Demographics.build_web_groups_data(char),
        description: Website.format_markdown_for_html(char.description || ""),
        status_message: Profile.get_profile_status_message(char),
        is_ooc: char.is_admin? || char.is_playerbit?,
        custom: Scenes.custom_char_card_fields(char, viewer)
      }
    end
  end
end