module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        client.emit "Lore Hooks All Characters"
        chars = Chargen.approved_chars
        chars.each do |c|

          client.emit "#{c.name}: #{c.lore_hook_type} - #{c.lore_hook_name} %R#{c.lore_hook_desc}"
        end
      end

    end
  end
end
