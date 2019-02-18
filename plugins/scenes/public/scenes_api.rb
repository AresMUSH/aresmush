module AresMUSH
  module Scenes

    def self.emit(enactor, pose, place_name = nil)
      Scenes.emit_pose(enactor, pose, true, false, place_name)
    end

    def self.emit_setpose(enactor, pose)
      Scenes.emit_pose(enactor, pose, true, false, nil, true)
    end

    def self.colorize_quotes(enactor, pose, recipient)
      Scenes.custom_format(pose, recipient, enactor)
    end

    def self.format_autospace(enactor, autospace_str)
      return autospace_str if !autospace_str
      autospace_str.gsub(/\%n/i, Demographics.name_and_nickname(enactor))
    end

    def self.add_to_scene(scene, pose, character = Game.master.system_character, is_setpose = nil, is_ooc = nil)
      return nil if !scene.logging_enabled

      scene_pose = ScenePose.create(pose: pose, character: character, scene: scene, is_setpose: is_setpose, is_ooc: is_ooc)
      if (!scene_pose.is_system_pose?)
        scene.participants.add character
      end

      scene.mark_unread(character)

      scene.update(last_activity: Time.now)
      Scenes.new_scene_activity(scene, scene_pose)
      if (!is_ooc)
        Scenes.handle_word_count_achievements(character, pose)
      end

      return scene_pose
    end

    def self.invite_to_scene(scene, char, enactor)
      if (!scene.invited.include?(char))
        scene.invited.add char
      end
      Login.emit_ooc_if_logged_in(char, t('scenes.scene_notify_invite', :name => enactor.name, :num => scene.id))
    end

    def self.uninvite_from_scene(scene, char, enactor)
      if (scene.invited.include?(char))
        scene.invited.delete char
      end
      Login.emit_ooc_if_logged_in(char, t('scenes.scene_notify_uninvited', :name => enactor.name, :num => scene.id))
    end

    def self.start_scene(enactor, location, private_scene, watchable_scene, scene_type, temp_room)
      scene = Scene.create(owner: enactor,
          location: location,
          private_scene: private_scene,
          watchable_scene: watchable_scene
          scene_type: scene_type,
          temp_room: temp_room,
          icdate: ICTime.ictime.strftime("%Y-%m-%d"))

      Global.logger.info "Scene #{scene.id} started by #{enactor.name} in #{temp_room ? 'temp room' : enactor.room.name}."

      if (temp_room)
        room = Scenes.create_scene_temproom(scene)
      else
        room = enactor.room
        room.update(scene: scene)
        scene.update(room: room)
        room.emit_ooc t('scenes.announce_scene_start', :privacy => private_scene ? "Private" : "Open", :name => enactor.name, :num => scene.id)
      end
      return scene
    end

  end
end
