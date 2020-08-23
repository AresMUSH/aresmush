module AresMUSH
  module Chargen
    class AppReviewRequestHandler
      def handle(request)
        enactor = request.enactor
        char = Character.find_one_by_name request.args[:id]
        
        error = Website.check_login(request)
        return error if error

        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        if (!Chargen.can_approve?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end

        if (char.is_approved?)
          return { error: t('chargen.already_approved', :name => char.name) }
        end
        
        if (!char.approval_job)
          return { error: t('chargen.no_app_submitted', :name => char.name) }
        end

        return Chargen.build_app_review_info(char, enactor)
      end
    end
  end
end


