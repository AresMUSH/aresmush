module AresMUSH
  module AltTracker
    class AltStatusRequestHandler
      def handle(request)
        enactor = request.enactor

        error = Website.check_login(request)
        return error if error

        data = AltTracker.status_for(enactor)

        if !data
          return { error: t('alttracker.not_registered') }
        end

        {
          email: data[:email],
          banned: data[:banned],
          characters: data[:characters].map { |c| {
            id: c.id,
            name: c.name,
            is_you: (c == enactor)
          }}
        }
      end
    end
  end
end
