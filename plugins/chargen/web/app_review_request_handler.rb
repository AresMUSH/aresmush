module AresMUSH
  module Chargen
    class AppReviewRequestHandler
      def handle(request)
        enactor = request.enactor
        char = Character.find_one_by_name request.args[:id]
        
        error = Website.check_login(request)
        return error if error

        if (!Chargen.can_approve?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end

        abilities_app = FS3Skills.is_enabled? ? MushFormatter.format(FS3Skills.app_review(char)) : nil
        demographics_app = MushFormatter.format Demographics.app_review(char)
        bg_app = MushFormatter.format Chargen.bg_app_review(char)
        desc_app = MushFormatter.format Describe.app_review(char)
        ranks_app = Ranks.is_enabled? ? MushFormatter.format(Ranks.app_review(char)): nil
        hooks_app = MushFormatter.format Chargen.hook_app_review(char)
        
        { 
          abilities: abilities_app,
          demographics: demographics_app,
          background: bg_app,
          desc: desc_app,
          ranks: ranks_app,
          hooks: hooks_app,
          name: char.name,
          id: char.id
        }
      end
    end
  end
end


