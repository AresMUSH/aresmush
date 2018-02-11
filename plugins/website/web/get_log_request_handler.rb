module AresMUSH
  module Website
    class GetLogRequestHandler
      def handle(request)
        enactor = request.enactor
        filename = request.args[:file]
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        path = File.join(AresMUSH.game_path, "logs", filename)
        lines = File.readlines(path).reverse
              
              
        {
          name: filename,
          text: lines.join('<br/>')
        }
      end
    end
  end
end