module AresMUSH
  module AltTracker
    class AltUpdateRequestHandler
      def handle(request)
        enactor = request.enactor
        new_value = request.args[:value]
        code_word = request.args[:code_word]

        error = Website.check_login(request)
        return error if error

        if !enactor.alt_tracker
          return { error: t('alttracker.not_registered') }
        end

        if new_value.blank?
          return { error: t('alttracker.value_required') }
        end

        if code_word.blank?
          return { error: t('alttracker.code_word_required') }
        end

        result = AltTracker.update_tracker(enactor, new_value, code_word)

        if !result
          return { error: t('alttracker.update_failed') }
        end

        case result[:changed]
        when :email
          { success: true, message: t('alttracker.email_updated', :email => result[:value]), changed: "email", value: result[:value] }
        when :code_word
          { success: true, message: t('alttracker.code_word_updated', :code_word => result[:value]), changed: "code_word", value: result[:value] }
        end
      end
    end
  end
end
