module AresMUSH
  module Profile
    class RelationshipsOrderCmd
      include CommandHandler
      
      attr_accessor :list

      def parse_args
        self.list = cmd.args
      end
      
      def required_args
        {
          args: [ self.list ],
          help: 'relationship'
        }
      end
      
      def check_for_commas
        return t('profile.relationships_use_commas') if self.list !~ /,/
        return nil
      end
      
      def handle
        categories = self.list.split(',')
        enactor.update(relationships_category_order: categories)
        client.emit_success t('profile.relationships_order', :categories => categories.join(","))
      end
    end
  end
end