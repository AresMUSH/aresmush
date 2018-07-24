module AresMUSH
  module Website
    class SaveColorsRequestHandler
      def handle(request)
        colors = request.args[:colors]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
                
        path = File.join(AresMUSH.game_path, "styles", "colors.scss")
        File.open(path, 'w') do |file|
          colors.each { |name, value| file.puts "$#{name}:#{value};"}
        end
        
        Website.rebuild_css
        
        {}
      end
    end
  end
end