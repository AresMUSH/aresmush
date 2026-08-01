module AresMUSH
  module AltTracker
    class AltRegisterRequestHandler
      def handle(request)
        enactor = request.enactor
        email = request.args[:email]
        code_word = request.args[:code_word]

        error = Website.check_login(request)
        return error if error

        if enactor.alt_tracker
          return { error: t('alttracker.already_registered') }
        end

        if !AltTracker.valid_email?(email)
          return { error: t('alttracker.invalid_email') }
        end

        if code_word.blank?
          return { error: t('alttracker.code_word_required') }
        end

        tracker = AltTracker.find_or_create_and_link(enactor, email, code_word)

        if tracker
          { success: true, message: t('alttracker.register_success') }
        else
          { error: t('alttracker.register_failed') }
        end
      end
    end
  end
end
