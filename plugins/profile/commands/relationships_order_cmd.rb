module AresMUSH
  module Profile
    class RelationshipsOrderCmd
      include CommandHandler
      
      attr_accessor :list

      def parse_args
        self.list = list_arg(cmd.args, ',')
      end
      
      def required_args
        [ self.list ]
      end
      
      def check_for_commas
        return t('profile.relationships_use_commas') if self.list.length == 0
        return nil
      end
      
      def handle
        order = self.list.map { |o| o.strip }
        enactor.update(relationships_category_order: order)
        client.emit_success t('profile.relationships_order', :categories => order.join(","))
      end
    end
  end
end