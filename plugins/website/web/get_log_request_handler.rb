module AresMUSH
  module Website
    class GetLogRequestHandler
      def handle(request)
        enactor = request.enactor
        filename = request.args[:file]
        
        error = Website.check_login(request)
        return error if error
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        path = File.join(AresMUSH.game_path, "logs", filename)
        
        if (!File.exists?(path))
          return { error: t('webportal.not_found') }
        end
        
        lines = File.readlines(path).reverse
              
              
        {
          name: filename,
          lines: lines
        }
      end
    end
  end
end