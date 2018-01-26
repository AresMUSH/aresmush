module AresMUSH
  module Chargen
    class ChargenReviewRequestHandler
      def handle(request)
        char = request.enactor
        chargen_data = request.args[:char]
                
        if (!char)
          return { error: "You must log in first." }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (char.is_approved?)
          return { error: "You have already completed character creation." }
        end
        
        if (char.chargen_locked)
          return { error: "Your character is locked from changes while your application is being reviewed." }
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
          hooks: hooks_app
        }
      end
    end
  end
end


