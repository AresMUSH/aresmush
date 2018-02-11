module AresMUSH
  module Profile
    class RelationshipDeleteCmd
      include CommandHandler
      
      attr_accessor :name
     
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        relations = enactor.relationships
        if (relations[self.name])
          relations.delete self.name
          enactor.update(relationships: relations)
          client.emit_success t('profile.relationship_deleted', :name => self.name)
        else
          client.emit_failure t('profile.relationship_not_found', :name => self.name)
        end        
      end
    end
  end
end