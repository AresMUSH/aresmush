module AresMUSH
  class PlotLink < Ohm::Model
    reference :scene, "AresMUSH::Scene"
    reference :plot, "AresMUSH::Plot"
    
    index :scene
    index :plot
    
    def self.find_link(plot, scene)
      #PlotLink.all.select { |l| l.plot == plot && l.scene == scene }.first
      PlotLink.find(plot_id: plot.id).combine(scene_id: scene.id).first
    end
    
    def self.find_by_plot(plot)
      #PlotLink.all.select { |l| l.plot == plot }
      PlotLink.find(plot_id: plot.id)
    end

    def self.find_by_scene(scene)
      #PlotLink.all.select { |l| l.scene == scene }
      PlotLink.find(scene_id: scene.id)
    end
  end
end