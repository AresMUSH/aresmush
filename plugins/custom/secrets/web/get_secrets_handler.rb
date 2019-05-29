module AresMUSH
  module Custom
    class GetSecretsRequestHandler
      def handle(request)
        Global.logger.debug "Hitting the handler"

        error = Website.check_login(request, true)
        return error if error

        chars = Chargen.approved_chars.sort_by { |c| c.name}


        secrets = []

        chars.each do |c|
           char_data = {
                  id: c.id,
                  name: c.name,
                  icon: Website.icon_for_char(c),
                  secret_name: c.secret_name,
                  secret_plot: c.secret_plot,
                  secret_summary: c.secret_summary
                }
            secrets << char_data
        end
        Global.logger.debug secrets

            {
              secrets: secrets
            }



      end

    end
  end
end
