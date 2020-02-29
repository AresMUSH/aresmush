module AresMUSH
  class Plot < Ohm::Model
    include ObjectModel
    
    attribute :title
    attribute :description
    attribute :summary
    attribute :completed, :type => DataType::Boolean
    attribute :content_warning
    
    collection :scenes, "AresMUSH::Scene"
    set :storytellers, "AresMUSH::Character"
    
    ## DEPRECATED!  No longer used.
    reference :storyteller, "AresMUSH::Character"
    
    
    def sorted_scenes
      self.scenes.to_a.sort_by { |s| s.icdate }
    end
    
    def start_date
      first_scene = self.sorted_scenes[0]
      first_scene ? first_scene.icdate : nil
    end

    def end_date
      last_scene = self.sorted_scenes[-1]
      last_scene ? last_scene.icdate : nil
    end
    
    def is_open?
      !self.completed
    end
  end
end
