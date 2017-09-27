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
        [ self.name, self.relationship, self.category ]
      end
      
      def handle
        relations = enactor.relationships
        if (relations.has_key?(self.name)) 
          order = relations[self.name]['order']
        else
          order = nil
        end
        
        relations[self.name] = { :category => self.category, :relationship => self.relationship, :order => order }
        enactor.update(relationships: relations)
        client.emit_success t('profile.relationship_set', :name => self.name)
      end
    end
  end
end