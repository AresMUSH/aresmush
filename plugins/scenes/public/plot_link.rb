module AresMUSH
  class PlotLink < Ohm::Model
    reference :log, "AresMUSH::Scene"
    reference :plot, "AresMUSH::Plot"
    
    index :log
    index :plot
  end
end