module AresMUSH
  module Website
    class EditPluginsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end

        config = Global.read_config("plugins")

        plugins = []
        
        config["optional_plugins"].each do |p|
          plugins << { name: p, selected: !config["disabled_plugins"].include?(p), optional: true }
        end
        
        config["disabled_plugins"].each do |p|
          if (!config["optional_plugins"].include?(p))
            plugins << { name: p, selected: false, optional: false }
          end
        end
        
        plugins.sort_by { |p| p[:name] }
      end
    end
  end
end