module AresMUSH
  module Lorehooks
    class GetLoreHooksRequestHandler
      def handle(request)

        error = Website.check_login(request, true)
        return error if error

        active_chars_list = Chargen.approved_chars.sort_by { |c| c.name}


        active_chars = []

        active_chars_list.each do |c|
          if c.lore_hook_type == "Item"
            item = c.lore_hook_name
          elsif c.lore_hook_type == "Pet"
            pet = c.lore_hook_name.gsub(" Pet","")
          elsif c.lore_hook_type == "Ancestry"
            ancestry = c.lore_hook_name.gsub(" Ancestry","")
          end
           char_data = {
                  id: c.id,
                  name: c.name,
                  icon: Website.icon_for_char(c),
                  lore_hook_name: c.lore_hook_name,
                  item: item,
                  pet: pet,
                  ancestry: ancestry,
                  lore_hook_desc: c.lore_hook_desc
                }
            active_chars << char_data
        end


        idle_chars_list = Character.all.select { |c| c.idle_state == 'Gone' }.sort_by { |c| c.name }

        idle_chars = []
        idle_chars_list.each do |c|
          if c.lore_hook_type == "Item"
            item = true
          elsif c.lore_hook_type == "Pet"
            pet = c.lore_hook_name.gsub(" Pet","")
          elsif c.lore_hook_type == "Ancestry"
            ancestry = c.lore_hook_name.gsub(" Ancestry","")
          end

           char_data = {
                  id: c.id,
                  name: c.name,
                  icon: Website.icon_for_char(c),
                  lore_hook_name: c.lore_hook_name,
                  item: item,
                  pet: pet,
                  ancestry: ancestry,
                  lore_hook_desc: c.lore_hook_desc
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
