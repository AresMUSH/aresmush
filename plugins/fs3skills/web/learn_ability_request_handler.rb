module AresMUSH
  module FS3Skills
    class LearnAbilityRequestHandler
      def handle(request)
        ability = request.args[:ability]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        request.log_request

        error = FS3Skills.learn_ability(enactor, ability)
        if (error)
          return { error: error }
        end
        
        {
        }
      end
    end
  end
end