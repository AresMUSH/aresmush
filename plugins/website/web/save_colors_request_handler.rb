module AresMUSH
  module Website
    class SaveColorsRequestHandler
      def handle(request)
        colors = request.args['colors']
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (!Website.can_manage_theme?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
                
        path = File.join(AresMUSH.game_path, "styles", "colors.scss")
        File.open(path, 'w') do |file|
          colors.each { |name, value| file.puts "$#{name}:#{value};"}
        end
        
        error = Website.rebuild_css
        if (error)
          return { error: error }
        end
        
        {}
      end
    end
  end
end