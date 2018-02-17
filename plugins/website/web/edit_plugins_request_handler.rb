module AresMUSH
  module Website
    class EditPluginsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end

        config = Global.read_config("plugins")

        plugins = []
        
        config["optional_plugins"].each do |p|
          plugins << { name: p, selected: !config["disabled_plugins"].include?(p) }
        end
        
        plugins
      end
    end
  end
end