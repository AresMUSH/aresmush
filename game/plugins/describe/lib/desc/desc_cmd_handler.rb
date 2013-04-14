module AresMUSH
  module Describe
    class DescCmdHandler
      def self.handle(model, desc, client)
        Describe.set_desc(model, desc)
        client.emit_success(t('describe.desc_set', :name => model["name"]))
      end
    end
  end
end