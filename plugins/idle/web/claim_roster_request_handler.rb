module AresMUSH
  module Idle
    class ClaimRosterRequestHandler
      def handle(request)
<<<<<<< HEAD

=======
                
>>>>>>> upstream/master
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error

        request.log_request
<<<<<<< HEAD

=======
                        
>>>>>>> upstream/master
        # Duplicated from check_login because we're allowing anonymous logins, just not banned sites.
        if (Login.is_banned?(enactor, request.ip_addr, request.hostname))
          return { status: 'error',  error: Login.site_blocked_message }
        end
<<<<<<< HEAD

        if !Login.creation_allowed?
          reason = Global.read_config('login', 'creation_not_allowed_message')
          return { status: 'error', error: t('login.creation_restricted', :reason => reason)}
        end

        char = Character[request.args[:id]]
        app = Website.format_input_for_mush((request.args[:app] || ""))

=======
            
        char = Character[request.args[:id]]
        app = Website.format_input_for_mush((request.args[:app] || ""))
        
>>>>>>> upstream/master
        if (!char)
          return { error: t('webportal.not_found') }
        end

        Global.logger.debug "Roster #{char.name} claimed by #{enactor ? enactor.name : 'Anonymous'} - #{request.ip_addr}."
<<<<<<< HEAD

        Idle.claim_roster(char, enactor, app)
=======
                
        Idle.claim_roster(char, enactor, app)    
>>>>>>> upstream/master
      end
    end
  end
end