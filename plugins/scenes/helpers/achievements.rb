module AresMUSH
  module Scenes
    def self.handle_word_count_achievements(char, pose)
      count = char.pose_word_count + "#{pose}".split.count
      char.update(pose_word_count: count)
      Achievements.achievement_levels("word_count").reverse.each do |level|
        if (count >= level)
          Achievements.award_achievement(char, "word_count", level)
          break
        end
      end
    end
        
    def self.handle_scene_participation_achievement(char, scene)
      return if Scenes.participated_in_scene?(char, scene)
      
      scenes = char.scenes_participated_in
      scenes << "#{scene.id}"
      char.update(scenes_participated_in: scenes)
      count = scenes.count
      
      Achievements.award_achievement(char, "scene_participant_#{scene.scene_type.downcase}")
      Achievements.achievement_levels("scene_participant").reverse.each do |level|
        if ( count >= level )
          Achievements.award_achievement(char, "scene_participant", level)
          break
        end
      end
    end
  end
end