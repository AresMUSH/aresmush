module AresMUSH
  module Profile
    class ProfileCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = !cmd.args ? enactor_name : titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          template = ProfileTemplate.new(enactor, model)
          client.emit template.render
        end
      end      
    end

  end
end
