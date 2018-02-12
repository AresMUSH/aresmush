module AresMUSH
  module Website
    class EditGameRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end

        config = Global.read_config("game")

        config['description'] = WebHelpers.format_input_for_html(config['description'])
        {
          config: config,
          status_options: [ 'In Development', 'Beta', 'Open', 'Closed', 'Sandbox' ],
          category_options: [ 'Social', 'Historical', 'Fantasy', 'Sci-Fi', 'Modern', 'Supernatural', 'Other' ]
        }
      end
    end
  end
end