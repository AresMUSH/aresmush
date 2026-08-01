module AresMUSH
  module AltTracker
    class AltRegisterAltRequestHandler
      def handle(request)
        enactor = request.enactor
        target_name = request.args[:name]
        code_word = request.args[:code_word]

        error = Website.check_login(request)
        return error if error

        if enactor.alt_tracker
          return { error: t('alttracker.already_registered') }
        end

        if target_name.blank?
          return { error: t('alttracker.alt_name_required') }
        end

        if code_word.blank?
          return { error: t('alttracker.code_word_required') }
        end

        other_char = Character.find_one_by_name(target_name)

        if !other_char
          return { error: t('alttracker.character_not_found') }
        end

        tracker = AltTracker.link_to_existing_alt(enactor, other_char, code_word)

        if tracker
          { success: true, message: t('alttracker.register_alt_success', :name => other_char.name) }
        else
          { error: t('alttracker.register_alt_failed') }
        end
      end
    end
  end
end
