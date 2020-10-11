module AresMUSH
    module Custom
        class PlotcheckCmd
            include CommandHandler

            def check_can_view
                return nil if enactor.has_permission?("view_bgs")
                return "You cannot use this command."
            end

            def handle 
                scene_info = Scene.all.filter {|s| s.plots.empty? && s.shared }.map {|s| "##{s.id} - #{s.title}"}.join "\n" 
                template = BorderedDisplayTemplate.new scene_info, "Scenes Without Plots:"
                client.emit template.render
            end
        end
    end
end