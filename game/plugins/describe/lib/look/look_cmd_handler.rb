module AresMUSH
  module Describe
    class LookCmdHandler
      def self.handle(desc_iface, model, client)
        desc = desc_iface.get_desc(model)
        client.emit(desc)
      end
    end
  end
end
