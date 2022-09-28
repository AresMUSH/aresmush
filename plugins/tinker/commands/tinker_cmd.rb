module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        Character.all.each do |c|
          c.spells_learned.each do |s|
            s.delete
          end
        end
        client.emit_success "Done!"
      end

    end
  end
end
