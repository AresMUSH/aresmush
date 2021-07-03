module AresMUSH
  module Idle
    class RosterApproveRequestHandler
      def handle(request)
        name = request.args['name']
        is_approved = (request.args['approved'] || "").to_bool
        
        enactor = request.enactor

        error = Website.check_login(request)
        return error if error

        model = Character.named(name)
        if (!model)
          return { error: t('webportal.not_found') }
        end
        
        request.log_request

        if !Idle.can_manage_roster?(enactor)
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (is_approved)
          error = Idle.approve_roster(enactor, model, '')
        else
          error = Idle.reject_roster(enactor, model, '')
        end
        
        if (error)
          return { error: error }
        end

        {}
      end
    end
  end
end