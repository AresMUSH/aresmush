module AresMUSH
  module Idle
    class ClaimRosterRequestHandler
      def handle(request)

        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error

        request.log_request

        # Duplicated from check_login because we're allowing anonymous logins, just not banned sites.
        if (Login.is_banned?(enactor, request.ip_addr, request.hostname))
          return { status: 'error',  error: Login.site_blocked_message }
        end

        if !Login.creation_allowed?
          reason = Global.read_config('login', 'creation_not_allowed_message')
          return { status: 'error' error: t('login.creation_restricted', :reason => reason)}
        end

        char = Character[request.args[:id]]
        app = Website.format_input_for_mush((request.args[:app] || ""))

        if (!char)
          return { error: t('webportal.not_found') }
        end

        Global.logger.debug "Roster #{char.name} claimed by #{enactor ? enactor.name : 'Anonymous'} - #{request.ip_addr}."

        Idle.claim_roster(char, enactor, app)
      end
    end
  end
end