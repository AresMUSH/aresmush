module AresMUSH
  module Custom
    class GetSecretsRequestHandler
      def handle(request)

        error = Website.check_login(request, true)
        return error if error

        active_chars_list = Chargen.approved_chars.sort_by { |c| c.name}


        active_chars = []

        active_chars_list.each do |c|
           char_data = {
                  id: c.id,
                  name: c.name,
                  icon: Website.icon_for_char(c),
                  secret_name: c.secret_name,
                  secret_plot: c.secret_plot,
                  secret_summary: c.secret_summary
                }
            active_chars << char_data
        end


        idle_chars_list = Character.all.select { |c| c.idle_state == 'Gone' }.sort_by { |c| c.name }

        idle_chars = []
        idle_chars_list.each do |c|
           char_data = {
                  id: c.id,
                  name: c.name,
                  icon: Website.icon_for_char(c),
                  secret_name: c.secret_name,
                  secret_plot: c.secret_plot,
                  secret_summary: c.secret_summary
                }
            idle_chars << char_data
        end

            {
              active_chars: active_chars,
              idle_chars: idle_chars
            }



      end

    end
  end
end
