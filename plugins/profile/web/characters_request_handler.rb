module AresMUSH
  module Profile
    class CharactersRequestHandler
      def handle(request)
        select = request.args[:select] || "approved"
        
        if (select == "all")
          chars = Character.all.to_a
        elsif (select == 'active')
          chars = Idle.active_chars
        else
          chars = Chargen.approved_chars
          if (select == "include_staff")
            chars.concat Roles.all_staff
            chars.concat Character.all.select { |c| c.is_npc? }
            chars << Game.master.system_character
          end
        end

        chars.uniq.sort_by { |c| c.name }.map { |c| {
                  id: c.id,
                  name: c.name,
                  icon: Website.icon_for_char(c)
                }}
      end
    end
  end
end