module AresMUSH
  module Website
    class GetLogsRequestHandler
      def handle(request)
        enactor = request.enactor
                
        error = Website.check_login(request)
        return error if error

        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        files = Global.logger.log_files
        
        if (!files.empty?)
          latest_log = File.read(Global.logger.latest_log_file)
          error_alert = (latest_log =~ /ERROR/) || (latest_log =~ /WARN/)
        else
          error_alert = nil
        end
              
        {
          logs: files.map { |f| { name: f.gsub(Global.logger.logs_path, '').gsub('/', '') } },
          error_alert: error_alert
        }
      end
    end
  end
end