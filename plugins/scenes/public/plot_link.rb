module AresMUSH
  class PlotLink < Ohm::Model
    reference :scene, "AresMUSH::Scene"
    reference :plot, "AresMUSH::Plot"
    
    index :scene
    index :plot
    
    def self.find_link(plot, scene)
      PlotLink.all.select { |l| l.plot == plot && l.scene == scene }.first
    end
    
    def self.find_by_plot(plot)
      PlotLink.all.select { |l| l.plot == plot }
    end

    def self.find_by_scene(scene)
      PlotLink.all.select { |l| l.scene == scene }
    end
  end
end