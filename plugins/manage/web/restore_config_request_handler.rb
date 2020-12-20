module AresMUSH
  module Manage
    class RestoreConfigRequestHandler
      def handle(request)
        enactor = request.enactor
        file = request.args[:file]
        
        error = Website.check_login(request)
        return error if error

        request.log_request

        if !Manage.can_manage_game?(enactor)
          return { error: t('dispatcher.not_allowed') }
        end

        error = Manage.restore_config(file)
        
        if (error)
          return { error: error }
        end
        
       {
       }
      end
    end
  end
end