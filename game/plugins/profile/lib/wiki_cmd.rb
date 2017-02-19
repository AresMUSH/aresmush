module AresMUSH
  module Profile
    class WikiCmd
      include CommandHandler
      
      attr_accessor :target

      def parse_args
        self.target = !cmd.args ? enactor_name : trim_arg(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          template =  WikiTemplate.new(model)
          client.emit template.render
        end
      end
    end
  end
end
