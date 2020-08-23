module AresMUSH
    module Custom
        class PlotcheckCmd
            include CommandHandler

            def check_can_view
                return nil if enactor.has_permission?("view_bgs")
                return "You do not have permission to use this command."
            end

            def handle 
                scene_info = Scenes.recent_scenes.map { |s| "#{s.icdate} - #{s.title} - #{s.plot ? s.plot.title : "%xrNO PLOT LINKED%xn" }" }.join "\n" 
                template = BorderedDisplayTemplate.new scene_info, "Scene List"
                client.emit template.render
            end
        end
    end
end