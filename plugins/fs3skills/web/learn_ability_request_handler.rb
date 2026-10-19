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

        can_manage_xp = FS3Skills.can_manage_xp?(enactor)
        if (!(AresCentral.is_alt?(enactor, char) || can_manage_xp))
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