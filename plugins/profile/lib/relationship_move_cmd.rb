module AresMUSH
  module Profile
    class RelationshipMoveCmd
      include CommandHandler
      
      attr_accessor :name, :relationship, :category

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.category = titlecase_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.category ]
      end
      
      def handle
        relations = enactor.relationships
        if (relations[self.name])
          relations[self.name][:category] = self.category
          enactor.update(relationships: relations)
          client.emit_success t('profile.relationship_set', :name => self.name)
        else
          client.emit_failure t('profile.relationship_not_found', :name => self.name)
        end 
      end
    end
  end
end