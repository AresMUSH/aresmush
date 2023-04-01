module AresMUSH
  module Mail
    class MailSendOptionsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        {
          authorableChars: AresCentral.alts(enactor)
            .sort_by { |a| [ a.name == enactor.name ? 0 : 1, a.name ] }
            .map { |a| {
              name: a.name,
              icon: Website.icon_for_char(a),
              id: a.id
              } }
        }
      end
    end
  end
end