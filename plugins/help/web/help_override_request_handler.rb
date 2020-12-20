module AresMUSH
  module Help
    class HelpOverrideRequestHandler
      def handle(request)
        topic_id = request.args[:topic]
        contents = request.args[:contents]
        
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        Global.logger.info "#{enactor.name} overriding help topic: #{topic_id}."
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
      
        help_dir = File.join(AresMUSH.game_path, "help", "en")
        FileUtils.mkpath(help_dir) unless File.exists?(help_dir)
        path =  File.join(help_dir, "#{topic_id}.md")
        
        
        File.open(path, "wb") { |f| f.write(contents) }
        Help.reload_help
        
        {
          topic: topic_id
        }
      end
    end
  end
end