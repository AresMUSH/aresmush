module AresMUSH
  module Chargen
    class CharAbilitiesRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:id]
        
        if (!char)
          return []
        end

        error = Website.check_login(request, true)
        return error if error
        
        if (FS3Skills.is_enabled?)
          abilities = FS3Skills::CharAbilitiesRequestHandler.new.handle(request)
        else
          abilities = []
        end
        
        
        return abilities
      end
    end
  end
end


