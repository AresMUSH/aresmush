module AresMUSH
  module Profile
    class RelationshipAddCmd
      include CommandHandler
      
      attr_accessor :name, :relationship, :category

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.name = titlecase_arg(args.arg1)
        self.category = titlecase_arg(args.arg2)
        self.relationship = args.arg3
      end
      
      def required_args
        {
          args: [ self.name, self.relationship, self.category ],
          help: 'relationship'
        }
      end
      
      def handle
        relations = enactor.relationships
        relations[self.name] = { :category => self.category, :relationship => self.relationship }
        enactor.update(relationships: relations)
        client.emit_success t('profile.relationship_set', :name => self.name)
      end
    end
  end
end