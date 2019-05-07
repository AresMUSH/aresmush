module AresMUSH
  module Who
    class HideCmd
      include CommandHandler

      def check_can_access
        return t('dispatcher.not_allowed') if !Who.can_be_hidden?(enactor)
        return nil
      end

      def handle
        if cmd.root_is?("unhide")
          client.emit_success(t('who.hide_disabled'))
          enactor.update(who_hidden: false)
        else
          client.emit_success(t('who.hide_enabled'))
          enactor.update(who_hidden: true)
        end
      end
    end
  end
end
