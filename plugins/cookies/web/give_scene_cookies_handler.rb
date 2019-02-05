module AresMUSH
  module Cookies
    class GiveSceneCookiesRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error

        Global.logger.debug "Scene #{scene.id} cookies given by #{enactor.name}."
        
        scene.participants.each do |c|
          if (c != enactor)
            Cookies.give_cookie(c, enactor)
          end
        end
         
        {
        }
      end
    end
  end
end