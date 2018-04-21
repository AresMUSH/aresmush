module AresMUSH
  module Manage
    class RubyCmd
      include CommandHandler
           
      def check_is_allowed
        return t('dispatcher.not_allowed') if !enactor.is_coder?
        return nil
      end
      
      def handle
        eval(cmd.args)
        client.emit_success t('global.done')
      end

    end
  end
end
