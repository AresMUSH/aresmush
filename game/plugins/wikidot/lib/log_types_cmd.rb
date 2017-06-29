module AresMUSH
  module Wikidot
    class LogTypesCmd
      include CommandHandler
      
      def handle
        client.emit_ooc t('wikidot.log_types', :types => Wikidot.log_types.join(", "))
      end
    end
  end
end
