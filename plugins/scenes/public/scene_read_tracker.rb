module AresMUSH
  class ReadTracker

    attribute :read_scenes, :type => DataType::Array, :default => []

    def is_scene_unread?(scene)
      scenes = self.read_scenes || []
      !scenes.include?("#{scene.id}")
    end
    
    def mark_scene_read(scene)
      scenes = self.read_scenes || []
      scenes << scene.id.to_s
      self.update(read_scenes: scenes.uniq)
    end

    def mark_scene_unread(scene)
      scenes = self.read_scenes || []
      scenes.delete scene.id.to_s
      self.update(read_scenes: scenes.uniq)
    end
  end
end