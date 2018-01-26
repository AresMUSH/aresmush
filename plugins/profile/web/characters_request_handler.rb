module AresMUSH
  module Profile
    class CharactersRequestHandler
      def handle(request)
        Chargen.approved_chars.sort_by { |c| c.name }.map { |c| {
                  id: c.id,
                  name: c.name,
                  icon: WebHelpers.icon_for_char(c)
                }}
      end
    end
  end
end