module AresMUSH
  module Profile
    class ProfileCmd
      include CommandHandler
      
      attr_accessor :name
      
      def crack!
        self.name = !cmd.args ? enactor.name : titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'profile'
        }
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
