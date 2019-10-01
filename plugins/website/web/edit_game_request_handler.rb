module AresMUSH
  module Website
    class EditGameRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end

        config = Global.read_config("game")

        config['description'] = Website.format_input_for_html(config['description'])
        {
          config: config,
          status_options: [ 'In Development', 'Alpha', 'Beta', 'Open', 'Closed', 'Sandbox' ],
          category_options: [ 'Social', 'Historical', 'Fantasy', 'Sci-Fi', 'Modern', 'Supernatural', 'Comic', 'Other' ]
        }
      end
    end
  end
end