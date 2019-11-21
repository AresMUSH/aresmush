module AresMUSH
  module Scenes
    def self.handle_word_count_achievements(char, pose)
      char.update(pose_word_count: char.pose_word_count + "#{pose}".split.count)
      [ 1000, 2000, 5000, 10000, 25000, 50000, 100000, 250000, 500000 ].reverse.each do |count|
        if (char.pose_word_count >= count)
          Achievements.award_achievement(char, "word_count", count)
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
      [ 1, 10, 20, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000 ].reverse.each do |level|
        if ( count >= level )
          Achievements.award_achievement(char, "scene_participant", level)
          break
        end
      end
    end
  end
end