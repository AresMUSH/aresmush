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
                  
      data = { 
          char: { name: scene_pose.character.name, icon: Website.icon_for_char(scene_pose.character) }, 
          order: scene_pose.order, 
          is_setpose: scene_pose.is_setpose,
          is_system_pose: scene_pose.is_system_pose?,
          is_ooc: scene_pose.is_ooc,
          pose: Website.format_markdown_for_html(scene_pose.pose) 
        }.to_json
      scene.update(last_activity: Time.now)
      Scenes.new_scene_activity(scene, data)
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
    
  end
end