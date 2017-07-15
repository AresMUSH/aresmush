module AresMUSH
  module Profile
    class RelationshipsCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = cmd.args || enactor_name
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          template = RelationshipsTemplate.new(model)
          client.emit template.render
        end
      end
    end
  end
end