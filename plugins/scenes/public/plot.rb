module AresMUSH
  class Plot < Ohm::Model
    include ObjectModel
    
    attribute :title
    attribute :description
    attribute :summary
    attribute :completed, :type => DataType::Boolean
    attribute :content_warning
    
    set :storytellers, "AresMUSH::Character"
    
    ## DEPRECATED!  No longer used.
    reference :storyteller, "AresMUSH::Character"
    collection :scenes, "AresMUSH::Scene"
    
    before_delete :on_delete
    
    def sorted_scenes
      self.plot_links.map { |p| p.scene }.sort_by { |s| s.icdate }
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
    
    def plot_links
      PlotLink.find_by_plot(self)
    end
    
    def on_delete
      self.plot_links.each { |p| p.delete }
    end
  end
end
