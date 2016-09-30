module AresMUSH
  module Profile
    class ProfileCmd
      include CommandHandler
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'profile'
        super
      end
      
      def crack!
        self.name = !cmd.args ? enactor.name : titleize_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          template = ProfileTemplate.new(client, model)
          client.emit template.render
        end
      end      
    end

  end
end
