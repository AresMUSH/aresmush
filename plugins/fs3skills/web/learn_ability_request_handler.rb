module AresMUSH
  module FS3Skills
    class LearnAbilityRequestHandler
      def handle(request)
        ability = request.args['ability']
        enactor = request.enactor
        char = Character.named(request.args['char']) || enactor
        
        error = Website.check_login(request)
        return error if error

        request.log_request

        if (!AresCentral.is_alt?(enactor, char))
          return { error: t('dispatcher.not_allowed') }
        end
        
        error = FS3Skills.learn_ability(char, ability)
        if (error)
          return { error: error }
        end
        
        {
        }
      end
    end
  end
end