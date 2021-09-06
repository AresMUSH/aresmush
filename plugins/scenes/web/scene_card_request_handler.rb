module AresMUSH
  module Scenes
    class GetSceneCardRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:char]
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error

        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        Scenes.build_char_card_web_data(char, enactor)
      end
    end
  end
end