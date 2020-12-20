module AresMUSH
  module Help
    class HelpRestoreRequestHandler
      def handle(request)
        topic_id = request.args[:topic]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
      
        Global.logger.info "#{enactor.name} restoring help topic: #{topic_id}."
      
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        path = File.join(AresMUSH.game_path, "help", "en", "#{topic_id}.md")
        if (File.exists?(path))
          FileUtils.rm(path)
          Help.reload_help
        else
          return { error: t('webportal.not_found') }
        end
        
        {
          topic: topic_id
        }
      end
    end
  end
end